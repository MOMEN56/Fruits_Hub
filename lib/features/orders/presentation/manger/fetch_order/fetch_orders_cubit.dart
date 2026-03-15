import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_hub/features/orders/data/services/orders_service.dart';
import 'package:fruit_hub/features/orders/domain/entities/dashboard_order_entity.dart';

part 'fetch_orders_state.dart';

class FetchOrdersCubit extends Cubit<FetchOrdersState> {
  FetchOrdersCubit(this.ordersService) : super(FetchOrdersInitial());

  final OrdersService ordersService;

  Future<void> fetchOrders() async {
    emit(FetchOrdersLoading());
    try {
      final groupedOrders = await ordersService.fetchGroupedOrders();
      emit(FetchOrdersSuccess(groupedOrders: groupedOrders));
    } catch (error, stackTrace) {
      log('fetchOrders failed: $error', stackTrace: stackTrace);
      emit(FetchOrdersFailure(errorMessage: error.toString()));
    }
  }
}
