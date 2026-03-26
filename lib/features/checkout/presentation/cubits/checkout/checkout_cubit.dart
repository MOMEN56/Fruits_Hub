import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entities/shipping_address_entity.dart';
import 'package:fruit_hub/features/home/domain/entities/cart_entity.dart';
import 'package:fruit_hub/generated/l10n.dart';
import 'package:equatable/equatable.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required CartEntity cartEntity, required String userId})
    : super(CheckoutState.initial(cartEntity: cartEntity, userId: userId));

  void moveToStep(int stepIndex) {
    if (stepIndex < 0 || stepIndex > CheckoutState.lastStepIndex) {
      return;
    }
    emit(state.copyWith(currentStepIndex: stepIndex));
  }

  void moveToNextStep() {
    moveToStep(state.currentStepIndex + 1);
  }

  void selectPaymentMethod({required bool payWithCash}) {
    if (state.orderInput.payWithCash == payWithCash) {
      return;
    }

    emit(
      state.copyWith(
        orderInput: state.orderInput.copyWith(payWithCash: payWithCash),
      ),
    );
  }

  void saveShippingAddress(ShippingAddressEntity shippingAddress) {
    emit(
      state.copyWith(
        orderInput: state.orderInput.copyWith(
          shippingAddressEntity: shippingAddress,
        ),
        addressAutovalidateMode: AutovalidateMode.disabled,
      ),
    );
  }

  void enableAddressAutovalidate() {
    if (state.addressAutovalidateMode == AutovalidateMode.always) {
      return;
    }

    emit(state.copyWith(addressAutovalidateMode: AutovalidateMode.always));
  }
}
