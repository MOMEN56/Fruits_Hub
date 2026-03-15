import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';
import 'package:meta/meta.dart';

@immutable
sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsUnauthenticated extends NotificationsState {
  const NotificationsUnauthenticated({required this.message});

  final String message;
}

final class NotificationsSuccess extends NotificationsState {
  const NotificationsSuccess({required this.notifications});

  final List<NotificationEntity> notifications;
}

final class NotificationsFailure extends NotificationsState {
  const NotificationsFailure({required this.message});

  final String message;
}
