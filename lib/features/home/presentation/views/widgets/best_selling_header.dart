import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/best_selling/presentation/view/best_selling_view.dart';

class BestSellingHeader extends StatelessWidget {
  const BestSellingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الأكثر مبيعًا',
            style: TextStyles.bold16.copyWith(color: const Color(0xFF0C0D0D)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popAndPushNamed(BestSellingView.routeName);
            },
            child: Text(
              'المزيد',
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
