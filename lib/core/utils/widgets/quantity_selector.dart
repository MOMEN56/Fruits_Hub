import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_item_cubit/cubit/cart_item_cubit.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    this.cartItemEntity,
    this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.scale = 1.0,
  }) : assert(
         cartItemEntity != null ||
             (quantity != null && onIncrement != null && onDecrement != null),
         'Provide cartItemEntity or quantity with increment/decrement callbacks.',
       );

  final CarItemEntity? cartItemEntity;
  final int? quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final double scale;

  bool get _isControlled => cartItemEntity == null;

  @override
  Widget build(BuildContext context) {
    final currentQuantity = _isControlled ? quantity! : cartItemEntity!.quantity;
    final buttonSize = 24 * scale;
    final buttonPadding = 2 * scale;
    final horizontalSpacing = 16 * scale;
    final quantityStyle = TextStyles.bold16.copyWith(
      fontSize: (TextStyles.bold16.fontSize ?? 16) * scale,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CartItemActionButton(
          icon: Icons.add,
          iconColor: Colors.white,
          color: AppColors.primaryColor,
          size: buttonSize,
          padding: buttonPadding,
          onPressed: () async {
            if (_isControlled) {
              onIncrement!();
              return;
            }
            final cartCubit = context.read<CartCubit>();
            final cartItemCubit = context.read<CartItemCubit>();
            await cartCubit.increaseProductQuantity(
              cartItemEntity!.productEntity,
            );
            cartItemCubit.updateCartItem(cartItemEntity!);
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
          child: Text(
            currentQuantity.toString(),
            textAlign: TextAlign.center,
            style: quantityStyle,
          ),
        ),
        CartItemActionButton(
          icon: Icons.remove,
          iconColor: Colors.grey,
          color: const Color(0xFFF3F5F7),
          size: buttonSize,
          padding: buttonPadding,
          onPressed: () async {
            if (_isControlled) {
              onDecrement!();
              return;
            }
            final cartCubit = context.read<CartCubit>();
            final cartItemCubit = context.read<CartItemCubit>();
            await cartCubit.decreaseProductQuantity(
              cartItemEntity!.productEntity,
            );
            cartItemCubit.updateCartItem(cartItemEntity!);
          },
        ),
      ],
    );
  }
}

class CartItemActionButton extends StatelessWidget {
  const CartItemActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.iconColor,
    this.size = 24,
    this.padding = 2,
  });

  final IconData icon;
  final Color iconColor;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: FittedBox(child: Icon(icon, color: iconColor)),
      ),
    );
  }
}
