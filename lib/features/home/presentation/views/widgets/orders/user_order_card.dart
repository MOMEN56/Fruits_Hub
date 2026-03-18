import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/widgets/custom_network_image.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_status_badge.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_ui_mapper.dart';
import 'package:fruit_hub/generated/l10n.dart';

class UserOrderCard extends StatelessWidget {
  const UserOrderCard({super.key, required this.order, this.onTap});

  final UserOrderEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBF9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3EAE4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderProductThumbnail(imageUrl: order.firstProductImageUrl),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.orderLabel(shortOrderId(order.orderId)),
                          style: TextStyles.bold16,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _productLabel(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.regular13.copyWith(
                            color: const Color(0xFF5D6A68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _OrderMetaChip(
                    icon: Icons.shopping_bag_outlined,
                    label: l10n.orderItemsCount(order.itemsCount),
                  ),
                  _OrderMetaChip(
                    icon: Icons.payments_outlined,
                    label: paymentMethodLabel(order.paymentMethod),
                  ),
                  _OrderMetaChip(
                    icon: Icons.attach_money,
                    label: l10n.priceWithCurrency(
                      order.totalPrice.toStringAsFixed(2),
                    ),
                  ),
                  if (order.createdAt != null)
                    _OrderMetaChip(
                      icon: Icons.schedule,
                      label: formatOrderDate(
                        order.createdAt!,
                        includeTime: true,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _productLabel() {
    final firstProductName = order.firstProductName?.trim();
    if (firstProductName == null || firstProductName.isEmpty) {
      return S.current.orderProducts;
    }
    if (order.itemsCount <= 1) return firstProductName;
    return '$firstProductName +${order.itemsCount - 1}';
  }
}

class _OrderProductThumbnail extends StatelessWidget {
  const _OrderProductThumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl?.trim();
    final hasImage = trimmedUrl != null && trimmedUrl.isNotEmpty;
    final resolvedImagePath = hasImage ? trimmedUrl : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 54,
        height: 54,
        child:
            resolvedImagePath != null
                ? _buildImage(resolvedImagePath)
                : const _ThumbnailFallback(),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CustomNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        fallback: const _ThumbnailFallback(),
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _ThumbnailFallback(),
    );
  }
}

class _ThumbnailFallback extends StatelessWidget {
  const _ThumbnailFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF4F0),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF8A9693),
      ),
    );
  }
}

class _OrderMetaChip extends StatelessWidget {
  const _OrderMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE4E7E5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF647270)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyles.semiBold11.copyWith(
              color: const Color(0xFF4F5B59),
            ),
          ),
        ],
      ),
    );
  }
}
