import 'dart:async';

import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsService {
  NotificationsService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabaseClient;
  final StreamController<List<NotificationEntity>> _notificationsController =
      StreamController<List<NotificationEntity>>.broadcast();

  RealtimeChannel? _realtimeChannel;
  String? _activeUserId;
  bool _isDisposed = false;

  Stream<List<NotificationEntity>> watchNotifications({required String userId}) {
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

    if (rows is! List) {
      return const <NotificationEntity>[];
    }

    return rows
        .whereType<Map>()
        .map((row) => NotificationEntity.fromJson(Map<String, dynamic>.from(row)))
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
    } catch (_) {
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
    _realtimeChannel = _supabaseClient.channel('public:notifications:$userId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: BackendEndpoint.notifications,
        callback: (_) {
          unawaited(refresh());
        },
      )
      ..subscribe();
  }

  void dispose() {
    _isDisposed = true;
    unawaited(_realtimeChannel?.unsubscribe());
    unawaited(_notificationsController.close());
  }
}
