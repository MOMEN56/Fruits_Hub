import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/usecases/add_order_use_case.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit(this._addOrderUseCase) : super(AddOrderInitial());

  final AddOrderUseCase _addOrderUseCase;
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
    final result = await _addOrderUseCase.call(order: order);
    result.fold((failure) {
      log('AddOrder failed: ${failure.message}');
      emit(AddOrderFailure(errorMessage: failure.message));
    }, (orderId) => emit(AddOrderSuccess(orderId: orderId)));
  }
}
