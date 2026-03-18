import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/shipping_item.dart';
import 'package:fruit_hub/generated/l10n.dart';

class ShippingSection extends StatelessWidget {
  const ShippingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final orderInput = context.watch<CheckoutCubit>().state.orderInput;
    final selectedIndex = switch (orderInput.payWithCash) {
      true => 0,
      false => 1,
      null => -1,
    };

    return Column(
      children: [
        const SizedBox(height: 33),
        ShippingItem(
          onTap: () {
            context.read<CheckoutCubit>().selectPaymentMethod(payWithCash: true);
          },
          isSelected: selectedIndex == 0,
          title: l10n.cashOnDelivery,
          subTitle: l10n.cashOnDeliverySubtitle,
          price: (orderInput.subTotalPrice + 30).toString(),
        ),
        const SizedBox(height: 16),
        ShippingItem(
          onTap: () {
            context.read<CheckoutCubit>().selectPaymentMethod(payWithCash: false);
          },
          isSelected: selectedIndex == 1,
          title: l10n.onlinePayment,
          subTitle: l10n.onlinePaymentSubtitle,
          price: orderInput.subTotalPrice.toString(),
        ),
      ],
    );
  }
}
