import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/checkout/presentation/views/checkout_view.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_item_cubit/cubit/cart_item_cubit.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CustomCartButton extends StatelessWidget {
  const CustomCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();

        return CustomButton(
          onPressed: () {
            if (cartCubit.cartEntity.cartItems.isNotEmpty) {
              Navigator.pushNamed(
                context,
                CheckoutView.routeName,
                arguments: CheckoutArgs(
                  cartEntity: cartCubit.cartEntity,
                  cartCubit: cartCubit,
                ),
              );
            } else {
              buildSnackBar(context, l10n.noItemsInCart);
            }
          },
          text: l10n.paymentButton(
            context
                .watch<CartCubit>()
                .cartEntity
                .calculateTotalPrice()
                .toString(),
          ),
        );
      },
    );
  }
}
