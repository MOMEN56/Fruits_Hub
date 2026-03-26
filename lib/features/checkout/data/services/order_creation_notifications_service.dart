import 'dart:developer';

import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/services/supabase_services.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderCreationNotificationsService {
  const OrderCreationNotificationsService(this._databaseService);

  final DatabaseService _databaseService;

  Future<void> notifyOrderCreated({
    required String userId,
    required String orderId,
  }) async {
    await _storeOrderCreatedNotifications(userId: userId, orderId: orderId);
    await _tryNotifyUserAboutOrderCreated(userId: userId, orderId: orderId);
    await _tryNotifyDashboardAboutNewOrder(orderId: orderId);
  }

  Future<void> _storeOrderCreatedNotifications({
    required String userId,
    required String orderId,
  }) async {
    try {
      await _databaseService.addData(
        path: BackendEndpoint.notifications,
        data: {
          'type': 'order_status',
          'title_ar': S.current.orderUpdate,
          'message_ar': S.current.pendingReview,
          'status': 'pending',
          'user_id': userId,
          'order_id': orderId,
          'is_read': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      await _databaseService.addData(
        path: BackendEndpoint.notifications,
        data: {
          'type': 'new_order',
          'title_ar': S.current.newOrder,
          'message_ar': S.current.customerCreatedNewOrder,
          'status': 'pending',
          'user_id': BackendEndpoint.adminNotificationsUserId,
          'order_id': orderId,
          'is_read': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (error, stackTrace) {
      log(
        '[OrderNotifications] Storing order-created notifications failed: $error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _tryNotifyUserAboutOrderCreated({
    required String userId,
    required String orderId,
  }) async {
    final databaseService = _databaseService;
    if (databaseService is! SupabaseService) {
      return;
    }

    try {
      final response = await databaseService.supabase.functions.invoke(
        BackendEndpoint.sendPushNotificationFunction,
        body: {
          'type': 'order_status',
          'target': 'user',
          'user_id': userId,
          'order_id': orderId,
          'status': 'pending',
          'title_ar': S.current.orderUpdate,
          'message_ar': S.current.pendingReview,
        },
      );
      log('[Push] User order-created response: ${response.data}');
    } catch (error, stackTrace) {
      log(
        '[Push] User order-created notification failed: $error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _tryNotifyDashboardAboutNewOrder({
    required String orderId,
  }) async {
    final databaseService = _databaseService;
    if (databaseService is! SupabaseService) {
      return;
    }

    try {
      final response = await databaseService.supabase.functions.invoke(
        BackendEndpoint.sendPushNotificationFunction,
        body: {
          'type': 'new_order',
          'target': 'user',
          'user_id': BackendEndpoint.adminNotificationsUserId,
          'order_id': orderId,
          'status': 'pending',
          'title_ar': S.current.newOrder,
          'message_ar': S.current.customerCreatedNewOrder,
        },
      );
      log('[Push] Dashboard new-order response: ${response.data}');
    } catch (error, stackTrace) {
      log(
        '[Push] Dashboard new-order notification failed: $error',
        stackTrace: stackTrace,
      );
    }
  }
}
