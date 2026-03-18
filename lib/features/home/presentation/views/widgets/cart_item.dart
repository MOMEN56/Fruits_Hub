import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/core/utils/widgets/custom_network_image.dart';
import 'package:fruit_hub/core/utils/widgets/quantity_selector.dart';
import 'package:fruit_hub/features/auth/domain/entites/cart_item_entity.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_item_cubit/cubit/cart_item_cubit.dart';
import 'package:fruit_hub/generated/l10n.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.carItemEntity});

  final CarItemEntity carItemEntity;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final quantityScale = MediaQuery.sizeOf(context).width < 380 ? 0.9 : 1.0;

    return BlocBuilder<CartItemCubit, CartItemState>(
      buildWhen: (previous, current) {
        if (current is CartItemUpdated) {
          return current.cartItemEntity == carItemEntity;
        }
        return false;
      },
      builder: (context, state) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 73,
                height: 92,
                decoration: const BoxDecoration(color: Color(0xFFF3F5F7)),
                child: CustomNetworkImage(
                  imageUrl: carItemEntity.productEntity.imageUrl!,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            carItemEntity.productEntity.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bold13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            await context.read<CartCubit>().deleteProduct(
                              carItemEntity,
                            );
                          },
                          child: SvgPicture.asset(Assets.assetsImagesTrashimage),
                        ),
                      ],
                    ),
                    Text(
                      l10n.grams(carItemEntity.calculateTotalWeight().toString()),
                      textAlign: TextAlign.right,
                      style: TextStyles.regular13.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        QuantitySelector(
                          cartItemEntity: carItemEntity,
                          scale: quantityScale,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                l10n.priceWithCurrency(
                                  carItemEntity
                                      .calculateTotalPrice()
                                      .toStringAsFixed(0),
                                ),
                                style: TextStyles.bold16.copyWith(
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
