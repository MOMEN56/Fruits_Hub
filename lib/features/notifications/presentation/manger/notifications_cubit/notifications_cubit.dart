import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/features/notifications/data/services/notifications_service.dart';
import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fruit_hub/generated/l10n.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._notificationsService, this._currentUserService)
    : super(NotificationsInitial());

  final NotificationsService _notificationsService;
  final CurrentUserService _currentUserService;
  StreamSubscription<List<NotificationEntity>>? _subscription;
  String? _activeUserId;

  void initialize() {
    final userId = _currentUserService.getCurrentUserId();
    if (userId == null) {
      emit(
        NotificationsUnauthenticated(
          message: S.current.unauthenticatedToViewNotifications,
        ),
      );
      return;
    }
    _loadNotificationsForUser(userId: userId);
  }

  void _loadNotificationsForUser({required String userId}) {
    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty) {
      emit(
        NotificationsFailure(message: S.current.unableToIdentifyCurrentUser),
      );
      return;
    }

    _activeUserId = normalizedUserId;
    emit(NotificationsLoading());
    _subscription?.cancel();
    _subscription = _notificationsService
        .watchNotifications(userId: normalizedUserId)
        .listen(
          (notifications) {
            emit(NotificationsSuccess(notifications: notifications));
          },
          onError: (error) {
            emit(NotificationsFailure(message: error.toString()));
          },
        );
  }

  Future<void> refresh() async {
    if (_activeUserId == null) {
      return;
    }
    await _notificationsService.refresh();
  }

  Future<void> markAsRead({required String notificationId}) async {
    final id = notificationId.trim();
    if (id.isEmpty) {
      return;
    }
    await _notificationsService.markAsRead(notificationId: id);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _notificationsService.dispose();
    return super.close();
  }
}
