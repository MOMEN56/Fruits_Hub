import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_hub/features/admin/orders/data/services/orders_service.dart';
import 'package:fruit_hub/features/admin/orders/domain/entities/dashboard_order_entity.dart';

part 'update_order_state.dart';

class UpdateOrderCubit extends Cubit<UpdateOrderState> {
  UpdateOrderCubit(this.ordersService) : super(UpdateOrderInitial());

  final OrdersService ordersService;

  Future<void> updateOrderStatus({
    required DashboardOrderEntity order,
    required String nextStatus,
  }) async {
    emit(UpdateOrderLoading(orderKey: order.orderKey));
    try {
      await ordersService.updateOrderStatus(order: order, nextStatus: nextStatus);
      emit(UpdateOrderSuccess(orderKey: order.orderKey, nextStatus: nextStatus));
    } catch (error, stackTrace) {
      log('updateOrderStatus failed: $error', stackTrace: stackTrace);
      emit(
        UpdateOrderFailure(
          orderKey: order.orderKey,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
