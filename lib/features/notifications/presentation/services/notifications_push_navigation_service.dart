import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fruit_hub/core/services/app_navigation_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/features/notifications/presentation/views/notifications_view.dart';

abstract final class NotificationsPushNavigationService {
  static bool _isInitialized = false;
  static NotificationsViewArgs? _pendingArgs;
  static bool _isNavigating = false;

  static void initialize() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    unawaited(_initializeInternal());
  }

  static Future<void> _initializeInternal() async {
    await getIt<PushNotificationService>().initialize(
      onNotificationTap: _openNotificationsFromPush,
    );
  }

  static Future<void> _openNotificationsFromPush(RemoteMessage message) async {
    final orderId = (message.data['order_id'] ?? '').toString().trim();
    _pendingArgs = NotificationsViewArgs(
      highlightedOrderId: orderId.isEmpty ? null : orderId,
    );
    await openPendingIfPossible();
  }

  static Future<void> openPendingIfPossible() async {
    if (_isNavigating || !AppNavigationService.isMainViewReady) {
      return;
    }

    final args = _pendingArgs;
    final navigatorState = AppNavigationService.navigatorKey.currentState;
    if (args == null || navigatorState == null) {
      return;
    }

    _isNavigating = true;
    _pendingArgs = null;
    try {
      await navigatorState.pushNamed(
        NotificationsView.routeName,
        arguments: args,
      );
    } finally {
      _isNavigating = false;
    }
  }
}
