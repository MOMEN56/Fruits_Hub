import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fruit_hub/core/services/app_navigation_service.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/features/notifications/presentation/views/notifications_view.dart';

abstract final class NotificationsPushNavigationService {
  static bool _isInitialized = false;
  static NotificationsViewArgs? _pendingArgs;

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
    final args = NotificationsViewArgs(
      highlightedOrderId: orderId.isEmpty ? null : orderId,
    );
    _pushToNotifications(args);
  }

  static void _pushToNotifications(NotificationsViewArgs args) {
    final navigatorState = AppNavigationService.navigatorKey.currentState;
    if (navigatorState == null) {
      _pendingArgs = args;
      Future<void>.delayed(Duration.zero, () {
        final pending = _pendingArgs;
        if (pending == null) {
          return;
        }
        _pendingArgs = null;
        AppNavigationService.navigatorKey.currentState?.pushNamed(
          NotificationsView.routeName,
          arguments: pending,
        );
      });
      return;
    }

    navigatorState.pushNamed(
      NotificationsView.routeName,
      arguments: args,
    );
  }
}
