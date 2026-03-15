part of 'fetch_orders_cubit.dart';

sealed class FetchOrdersState extends Equatable {
  const FetchOrdersState();

  @override
  List<Object?> get props => [];
}

final class FetchOrdersInitial extends FetchOrdersState {}

final class FetchOrdersLoading extends FetchOrdersState {}

final class FetchOrdersSuccess extends FetchOrdersState {
  const FetchOrdersSuccess({required this.groupedOrders});

  final List<UserOrdersGroupEntity> groupedOrders;

  @override
  List<Object?> get props => [groupedOrders];
}

final class FetchOrdersFailure extends FetchOrdersState {
  const FetchOrdersFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
