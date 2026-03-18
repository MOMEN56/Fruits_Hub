import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_ui_mapper.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderSummaryGrid extends StatelessWidget {
  const OrderSummaryGrid({super.key, required this.order});

  final UserOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasTwoColumns = constraints.maxWidth >= 280;
        final cardWidth =
            hasTwoColumns ? (constraints.maxWidth - 10) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SummaryCard(
              width: cardWidth,
              title: l10n.overallTotal,
              value: l10n.priceWithCurrency(order.totalPrice.toStringAsFixed(2)),
              icon: Icons.payments_outlined,
              accent: const Color(0xFFEAF7EE),
            ),
            _SummaryCard(
              width: cardWidth,
              title: l10n.paymentMethod,
              value: paymentMethodLabel(order.paymentMethod),
              icon: Icons.credit_card_outlined,
              accent: const Color(0xFFFFF2E0),
            ),
            _SummaryCard(
              width: cardWidth,
              title: l10n.productsCount,
              value: '${order.itemsCount}',
              icon: Icons.inventory_2_outlined,
              accent: const Color(0xFFE9F1FF),
            ),
            _SummaryCard(
              width: cardWidth,
              title: l10n.orderDate,
              value: order.createdAt != null ? formatOrderDate(order.createdAt!) : '--',
              icon: Icons.schedule,
              accent: const Color(0xFFF1ECFF),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5ECE6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: const Color(0xFF2D3A37)),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyles.regular11.copyWith(color: const Color(0xFF6E7A77)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bold13,
          ),
        ],
      ),
    );
  }
}
