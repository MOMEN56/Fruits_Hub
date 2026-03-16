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
            '\u0627\u0644\u0623\u0643\u062B\u0631 \u0645\u0628\u064A\u0639\u064B\u0627',
            style: TextStyles.bold16.copyWith(color: const Color(0xFF0C0D0D)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(BestSellingView.routeName);
            },
            child: Text(
              '\u0627\u0644\u0645\u0632\u064A\u062F',
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
