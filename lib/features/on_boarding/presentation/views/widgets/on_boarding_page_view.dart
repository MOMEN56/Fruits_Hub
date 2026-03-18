import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/widgets/on_boarding_page_view_item.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return PageView(
      controller: pageController,
      children: [
        OnBoardingPageViewItem(
          isVisible: true,
          image: Assets.assetsImagesOnBoardingPage1ViewItem,
          backgroundimage: Assets.assetsImagesOnBoardingPage1ViewItemBackground,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.welcomeTo, style: TextStyles.bold23),
              Text(
                '  HUB',
                style: TextStyles.bold23.copyWith(color: AppColors.secondaryColor),
              ),
              Text(
                'Fruit',
                style: TextStyles.bold23.copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
          subtitle: l10n.onboardingDiscoverSubtitle,
        ),
        OnBoardingPageViewItem(
          isVisible: false,
          image: Assets.assetsImagesOnBoardingPage2ViewItem,
          backgroundimage: Assets.assetsImagesOnBoardingPage2ViewItemBackground,
          subtitle: l10n.onboardingCuratedSubtitle,
          title: Text(
            l10n.searchAndShop,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0C0D0D),
              fontSize: 23,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
