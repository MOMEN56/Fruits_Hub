import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_product_tile.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_summary_grid.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/order_ui_mapper.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrderDetailsViewBody extends StatelessWidget {
  const OrderDetailsViewBody({super.key, required this.order});

  final UserOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF0F3E25), Color(0xFF2D9F5D), Color(0xFFF4A91F)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 52, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.orderDetailsTitle(shortOrderId(order.orderId)),
                        style: TextStyles.bold19.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        detailsStatusLabel(order.status),
                        style: TextStyles.semiBold13.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                order.shippingAddress ??
                                    l10n.shippingAddressUnavailable,
                                style: TextStyles.regular11.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: OrderSummaryGrid(order: order),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
            child: Row(
              children: [
                Text(l10n.products, style: TextStyles.bold19),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${order.products.length}',
                    style: TextStyles.semiBold13.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverList.builder(
            itemCount: order.products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OrderProductTile(product: order.products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
