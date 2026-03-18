import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/checkout/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:fruit_hub/features/checkout/presentation/views/widgets/payment_item.dart';
import 'package:fruit_hub/generated/l10n.dart';

class ShippingAddressWidget extends StatelessWidget {
  const ShippingAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final shippingAddress =
        context.watch<CheckoutCubit>().state.orderInput.shippingAddressEntity;

    return PaymentItem(
      title: l10n.deliveryAddress,
      child: Row(
        children: [
          SvgPicture.asset(Assets.assetsImagesLocation),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ' ${shippingAddress.displayAddress} ',
              textAlign: TextAlign.right,
              style: TextStyles.regular13.copyWith(
                color: const Color(0xFF4E5556),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<CheckoutCubit>().moveToStep(1);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Assets.assetsImagesEdit),
                const SizedBox(width: 4),
                Text(
                  l10n.edit,
                  style: TextStyles.semiBold13.copyWith(
                    color: const Color(0xFF949D9E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
