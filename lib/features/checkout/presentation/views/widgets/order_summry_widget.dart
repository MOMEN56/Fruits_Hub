import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/payment_item.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderSummryWidget extends StatelessWidget {
  const OrderSummryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final orderInput = context.watch<CheckoutCubit>().state.orderInput;

    return PaymentItem(
      title: l10n.orderSummary,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l10n.subtotal,
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              const Spacer(),
              Text(
                l10n.priceWithCurrency(orderInput.subTotalPrice.toString()),
                textAlign: TextAlign.right,
                style: TextStyles.semiBold16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                l10n.delivery,
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              const Spacer(),
              Text(
                l10n.priceWithCurrency(orderInput.shippingCost.toString()),
                textAlign: TextAlign.right,
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Divider(thickness: .5, color: Color(0xFFCACECE)),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(l10n.total, style: TextStyles.bold16),
              const Spacer(),
              Text(
                l10n.priceWithCurrency(orderInput.totalPrice.toString()),
                style: TextStyles.bold16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
