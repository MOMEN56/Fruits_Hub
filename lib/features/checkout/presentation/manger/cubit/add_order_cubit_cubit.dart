import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/features/checkout/domain/entities/order_entity.dart';

part 'add_order_cubit_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit(this.orderRepo) : super(AddOrderInitial());
  final OrderRepo orderRepo;
  int _paymentRequestCounter = 0;

  void submitOrder({required OrderInputEntity order}) {
    if (order.payWithCash == true) {
      addOrder(order: order);
      return;
    }

    emit(
      AddOrderNeedsOnlinePayment(
        order: order,
        requestId: ++_paymentRequestCounter,
      ),
    );
  }

  void addOrder({required OrderInputEntity order}) async {
    emit(AddOrderLoading());
    final result = await orderRepo.addOrder(order: order);
    result.fold((failure) {
      log('AddOrder failed: ${failure.message}');
      emit(AddOrderFailure(errorMessage: failure.message));
    }, (orderId) => emit(AddOrderSuccess(orderId: orderId)));
  }
}
