import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final illustrationWidth =
        (screenWidth * 0.45).clamp(170.0, 240.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.assetsImagesIllustrations,
            width: illustrationWidth,
          ),
          const SizedBox(height: 28),
          Text(
            'البحث',
            style: TextStyles.bold19.copyWith(color: const Color(0xFF0C0D0D)),
          ),
          const SizedBox(height: 8),
          Text(
            'عفوًا... هذه المعلومات غير متوفرة للحظة',
            textAlign: TextAlign.center,
            style: TextStyles.regular13.copyWith(color: const Color(0xFF949D9E)),
          ),
        ],
      ),
    );
  }
}
