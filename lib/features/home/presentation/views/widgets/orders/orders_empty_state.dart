import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 72),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FBF8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDCEADB)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF5EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                Text(l10n.noOrdersYet, style: TextStyles.bold16),
                const SizedBox(height: 8),
                Text(
                  l10n.startAddingProducts,
                  textAlign: TextAlign.center,
                  style: TextStyles.regular13.copyWith(
                    color: const Color(0xFF6B7677),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.pullDownToRefresh,
                  style: TextStyles.semiBold11.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
