part of 'user_orders_cubit.dart';

enum UserOrdersStatus { initial, loading, failure, success }

class UserOrdersState extends Equatable {
  const UserOrdersState({
    this.status = UserOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.hasUsableCache = false,
  });

  final UserOrdersStatus status;
  final List<UserOrderEntity> orders;
  final String? errorMessage;
  final bool hasUsableCache;

  UserOrdersState copyWith({
    UserOrdersStatus? status,
    List<UserOrderEntity>? orders,
    String? errorMessage,
    bool? hasUsableCache,
    bool? clearErrorMessage,
  }) {
    return UserOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearErrorMessage == true
          ? null
          : errorMessage ?? this.errorMessage,
      hasUsableCache: hasUsableCache ?? this.hasUsableCache,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        errorMessage,
        hasUsableCache,
      ];
}
