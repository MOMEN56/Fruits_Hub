import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_product_entity.dart';

class OrderProductTile extends StatelessWidget {
  const OrderProductTile({super.key, required this.product});

  final UserOrderProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4ECE6)),
      ),
      child: Row(
        children: [
          _ProductImage(imageUrl: product.imageUrl),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyles.bold13,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'كود: ${product.code.isEmpty ? '--' : product.code}',
                  style: TextStyles.regular11.copyWith(color: const Color(0xFF70807B)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'الكمية: ${product.quantity}',
                        style: TextStyles.semiBold11.copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(product.price * product.quantity).toStringAsFixed(2)} جنيه',
                      style: TextStyles.bold13.copyWith(color: AppColors.secondaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final path = hasImage ? imageUrl!.trim() : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 74,
        height: 74,
        child:
            hasImage
                ? (path.startsWith('http://') || path.startsWith('https://')
                    ? Image.network(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _ProductImageFallback(),
                    )
                    : Image.asset(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _ProductImageFallback(),
                    ))
                : const _ProductImageFallback(),
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF4F0),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF85948F)),
    );
  }
}
