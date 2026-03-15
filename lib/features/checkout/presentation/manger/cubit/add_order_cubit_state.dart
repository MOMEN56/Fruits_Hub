part of 'add_order_cubit_cubit.dart';

sealed class AddOrderState extends Equatable {
  const AddOrderState();

  @override
  List<Object> get props => [];
}

final class AddOrderInitial extends AddOrderState {}

final class AddOrderLoading extends AddOrderState {}

final class AddOrderNeedsOnlinePayment extends AddOrderState {
  final OrderInputEntity order;
  final int requestId;

  const AddOrderNeedsOnlinePayment({
    required this.order,
    required this.requestId,
  });

  @override
  List<Object> get props => [requestId];
}

final class AddOrderSuccess extends AddOrderState {}

final class AddOrderFailure extends AddOrderState {
  final String errorMessage;

  const AddOrderFailure({required this.errorMessage});
}
