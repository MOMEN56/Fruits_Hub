import 'package:flutter/material.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/widgets/quantity_selector.dart';
import 'package:fruit_hub/generated/l10n.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.productEntity,
    required this.selectedQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final ProductEntity productEntity;
  final int selectedQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final quantityScale = MediaQuery.sizeOf(context).width < 380 ? 1.0 : 1.12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    productEntity.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyles.bold16,
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.pricePerKilo(productEntity.price.toStringAsFixed(0)),
                      textAlign: TextAlign.right,
                      style: TextStyles.bold13.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            QuantitySelector(
              quantity: selectedQuantity,
              scale: quantityScale,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l10n.review,
              style: TextStyles.bold13.copyWith(
                color: const Color(0xFF1B5E37),
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(30+)',
              style: TextStyles.semiBold13.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 4),
            Text(
              '4.5',
              style: TextStyles.semiBold13.copyWith(color: Colors.black),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.star, color: Colors.amber, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          productEntity.description,
          textAlign: TextAlign.right,
          style: TextStyles.regular13.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
