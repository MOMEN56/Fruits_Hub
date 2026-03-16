import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/widgets/custom_button.dart';
import 'package:fruit_hub/features/checkout/presentation/views/checkout_view.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_item_cubit/cubit/cart_item_cubit.dart';

class CustomCartButton extends StatelessWidget {
  const CustomCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        return CustomButton(
          onPressed: () {
            if (context.read<CartCubit>().cartEntity.cartItems.isNotEmpty) {
              Navigator.pushNamed(
                context,
                CheckoutView.routeName,
                arguments: CheckoutArgs(
                  cartEntity: context.read<CartCubit>().cartEntity,
                  cartCubit: context.read<CartCubit>(),
                ),
              );
            } else {
              buildSnackBar(
                context,
                '\u0644\u0627 \u064A\u0648\u062C\u062F \u0645\u0646\u062A\u062C\u0627\u062A \u0641\u064A \u0627\u0644\u0633\u0644\u0629',
              );
            }
          },
          text:
              '\u0627\u0644\u062F\u0641\u0639 ${context.watch<CartCubit>().cartEntity.calculateTotalPrice()} \u062C\u0646\u064A\u0647',
        );
      },
    );
  }
}
