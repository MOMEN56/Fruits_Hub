part of 'add_order_cubit.dart';

sealed class AddOrderState extends Equatable {
  const AddOrderState();

  @override
  List<Object?> get props => [];
}

final class AddOrderInitial extends AddOrderState {
  const AddOrderInitial();
}

final class AddOrderLoading extends AddOrderState {
  const AddOrderLoading();
}

final class AddOrderNeedsOnlinePayment extends AddOrderState {
  const AddOrderNeedsOnlinePayment({
    required this.order,
    required this.requestId,
  });

  final OrderInputEntity order;
  final int requestId;

  @override
  List<Object?> get props => [order, requestId];
}

final class AddOrderSuccess extends AddOrderState {
  const AddOrderSuccess({required this.orderId});

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

final class AddOrderFailure extends AddOrderState {
  const AddOrderFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
