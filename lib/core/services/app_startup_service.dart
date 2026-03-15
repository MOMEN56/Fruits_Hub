import 'package:fruit_hub/core/services/payment_service.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/features/notifications/presentation/services/notifications_push_navigation_service.dart';

abstract final class AppStartupService {
  static void initialize() {
    PushNotificationService.configureBackgroundHandler();
    PaymentService.initialize();
    NotificationsPushNavigationService.initialize();
  }
}
