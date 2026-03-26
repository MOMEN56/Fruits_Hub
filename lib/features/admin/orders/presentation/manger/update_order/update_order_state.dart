part of 'update_order_cubit.dart';

sealed class UpdateOrderState extends Equatable {
  const UpdateOrderState();

  @override
  List<Object?> get props => [];
}

final class UpdateOrderInitial extends UpdateOrderState {}

final class UpdateOrderLoading extends UpdateOrderState {
  const UpdateOrderLoading({required this.orderKey});

  final String orderKey;

  @override
  List<Object?> get props => [orderKey];
}

final class UpdateOrderSuccess extends UpdateOrderState {
  const UpdateOrderSuccess({required this.orderKey, required this.nextStatus});

  final String orderKey;
  final String nextStatus;

  @override
  List<Object?> get props => [orderKey, nextStatus];
}

final class UpdateOrderFailure extends UpdateOrderState {
  const UpdateOrderFailure({required this.orderKey, required this.errorMessage});

  final String orderKey;
  final String errorMessage;

  @override
  List<Object?> get props => [orderKey, errorMessage];
}
