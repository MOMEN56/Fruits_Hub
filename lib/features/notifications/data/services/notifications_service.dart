import 'dart:async';

import 'package:fruit_hub/core/connectivity/connection_service.dart';
import 'package:fruit_hub/core/connectivity/connection_status.dart';
import 'package:fruit_hub/core/connectivity/network_error_matcher.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsService {
  NotificationsService({
    SupabaseClient? supabaseClient,
    ConnectionService? connectionService,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client,
       _connectionService = connectionService {
    _connectionSubscription = _connectionService?.stream.listen(
      _handleConnectionStatusChange,
    );
  }

  final SupabaseClient _supabaseClient;
  final ConnectionService? _connectionService;
  final StreamController<List<NotificationEntity>> _notificationsController =
      StreamController<List<NotificationEntity>>.broadcast();

  RealtimeChannel? _realtimeChannel;
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  String? _activeUserId;
  bool _isDisposed = false;
  bool _shouldResubscribeOnReconnect = false;

  Stream<List<NotificationEntity>> watchNotifications({
    required String userId,
  }) {
    if (_activeUserId != userId) {
      _activeUserId = userId;
      _subscribeToRealtimeChanges();
    }
    unawaited(refresh());
    return _notificationsController.stream;
  }

  Future<List<NotificationEntity>> fetchNotifications({
    required String userId,
  }) async {
    final rows = await _supabaseClient
        .from(BackendEndpoint.notifications)
        .select()
        .or('user_id.eq.$userId,user_id.is.null')
        .order('created_at', ascending: false);

    return rows
        .whereType<Map>()
        .map(
          (row) => NotificationEntity.fromJson(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<void> markAsRead({required String notificationId}) async {
    final id = notificationId.trim();
    if (id.isEmpty) {
      return;
    }
    await _supabaseClient
        .from(BackendEndpoint.notifications)
        .update({'is_read': true})
        .eq('id', id);
    await refresh();
  }

  Future<void> refresh() async {
    if (_isDisposed) {
      return;
    }
    final userId = _activeUserId;
    if (userId == null) {
      return;
    }
    try {
      final notifications = await fetchNotifications(userId: userId);
      if (!_isDisposed && !_notificationsController.isClosed) {
        _notificationsController.add(notifications);
      }
    } catch (error) {
      if (isLikelyNetworkError(error)) {
        _connectionService?.reportConnectionIssue();
      }
      if (!_isDisposed && !_notificationsController.isClosed) {
        _notificationsController.add(const <NotificationEntity>[]);
      }
    }
  }

  void _subscribeToRealtimeChanges() {
    final userId = _activeUserId;
    if (_isDisposed || userId == null) {
      return;
    }

    unawaited(_realtimeChannel?.unsubscribe());
    _realtimeChannel =
        _supabaseClient.channel('public:notifications:$userId')
          ..onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: BackendEndpoint.notifications,
            callback: (_) {
              unawaited(refresh());
            },
          )
          ..subscribe((status, _) {
            if (status == RealtimeSubscribeStatus.subscribed) {
              _shouldResubscribeOnReconnect = false;
              return;
            }

            if (status == RealtimeSubscribeStatus.channelError) {
              _shouldResubscribeOnReconnect = true;
              _connectionService?.reportRealtimeChannelError();
            }
          });
  }

  void _handleConnectionStatusChange(ConnectionStatus status) {
    if (_isDisposed ||
        !_shouldResubscribeOnReconnect ||
        status != ConnectionStatus.online) {
      return;
    }

    _shouldResubscribeOnReconnect = false;
    _subscribeToRealtimeChanges();
    unawaited(refresh());
  }

  void dispose() {
    _isDisposed = true;
    unawaited(_connectionSubscription?.cancel());
    unawaited(_realtimeChannel?.unsubscribe());
    unawaited(_notificationsController.close());
  }
}
