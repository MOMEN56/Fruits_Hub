import 'package:flutter/material.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/widgets/quantity_selector.dart';

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

  /// ودجت اختياري يظهر أسفل القسم

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // اسم المنتج + السعر + QuantitySelector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productEntity.name,
                  style: TextStyles.bold16,
                  textAlign: TextAlign.right,
                ),
                Text(
                  '${productEntity.price} جنيه / الكيلو',
                  style: TextStyles.bold13.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            QuantitySelector(
              quantity: selectedQuantity,
              scale: 1.22,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ],
        ),

        const SizedBox(height: 8),

        // تقييم المنتج
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '4.5',
              style: TextStyles.semiBold13.copyWith(color: Colors.black),
            ),
            const SizedBox(width: 4),
            Text(
              '(30+)',
              style: TextStyles.semiBold13.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 4),
            Text(
              'المراجعة',
              style: TextStyles.bold13.copyWith(
                color: const Color(0xFF1B5E37),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // وصف المنتج
        Text(
          productEntity.description,
          textAlign: TextAlign.right,
          style: TextStyles.regular13.copyWith(color: Colors.grey),
        ),

        const SizedBox(height: 24),

        // زر أو أي ودجت إضافي
      ],
    );
  }
}
