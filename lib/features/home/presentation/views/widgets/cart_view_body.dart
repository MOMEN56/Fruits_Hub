import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/cart_header.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/cart_item_list.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/custom_cart_button.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final cartItems = context.watch<CartCubit>().cartEntity.cartItems;
    final hasItems = cartItems.isNotEmpty;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: kTopPaddding),
                        buildAppBar(
                          context,
                          title: 'السلة',
                          showNotification: false,
                          showBackButton: false,
                        ),
                        const SizedBox(height: 16),
                        const CartHeader(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: hasItems ? const CustomDivider() : const SizedBox(),
                  ),
                  CarItemsList(carItems: cartItems),
                  SliverToBoxAdapter(
                    child: hasItems ? const CustomDivider() : const SizedBox(),
                  ),
                  if (hasItems)
                    const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
              if (hasItems)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.paddingOf(context).bottom + 12,
                  child: const CustomCartButton(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
