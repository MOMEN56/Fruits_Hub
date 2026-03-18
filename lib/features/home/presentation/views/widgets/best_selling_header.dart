import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/best_selling/presentation/view/best_selling_view.dart';
import 'package:fruit_hub/generated/l10n.dart';

class BestSellingHeader extends StatelessWidget {
  const BestSellingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.mostSelling,
            style: TextStyles.bold16.copyWith(color: const Color(0xFF0C0D0D)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(BestSellingView.routeName);
            },
            child: Text(
              l10n.more,
              style: TextStyles.regular13.copyWith(
                color: const Color(0xFF949D9E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
