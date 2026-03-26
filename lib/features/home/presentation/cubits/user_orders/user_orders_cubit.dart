import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/features/checkout/domain/entities/user_order_entity.dart';
import 'package:fruit_hub/features/home/domain/usecases/get_user_orders_use_case.dart';
import 'package:fruit_hub/generated/l10n.dart';

part 'user_orders_state.dart';

class UserOrdersCubit extends Cubit<UserOrdersState> {
  UserOrdersCubit(this._getUserOrdersUseCase, this._currentUserService)
    : super(const UserOrdersState());

  final GetUserOrdersUseCase _getUserOrdersUseCase;
  final CurrentUserService _currentUserService;

  Future<void> loadOrders() async {
    final userId = _currentUserService.getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          status: UserOrdersStatus.failure,
          errorMessage: S.current.unableToIdentifyCurrentUser,
        ),
      );
      return;
    }

    if (!state.hasUsableCache) {
      emit(
        state.copyWith(
          status: UserOrdersStatus.loading,
          clearErrorMessage: true,
        ),
      );
    }

    final result = await _getUserOrdersUseCase.call(userId: userId);
    result.fold(
      (failure) {
        if (state.hasUsableCache) {
          emit(state.copyWith(errorMessage: failure.message));
          return;
        }

        emit(
          state.copyWith(
            status: UserOrdersStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (orders) {
        emit(
          state.copyWith(
            status: UserOrdersStatus.success,
            orders: orders,
            hasUsableCache: true,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }
}
