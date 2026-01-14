import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/widgets/on_boarding_page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: pageController,
        children: [
          OnBoardingPageViewItem(
            isVisible: true,
            image: Assets.assetsImagesOnBoardingPage1ViewItem,
            backgroundimage:
                Assets.assetsImagesOnBoardingPage1ViewItemBackground,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('مرحبًا بك في', style: TextStyles.bold23),
                Text(
                  '  HUB',
                  style: TextStyles.bold23.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  'Fruit',
                  style: TextStyles.bold23.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            subtitle:
                "اكتشف تجربة تسوق فريدة مع FruitHUB. استكشف مجموعتنا الواسعة من الفواكه الطازجة الممتازة واحصل على أفضل العروض والجودة العالية.",
          ),
          OnBoardingPageViewItem(
            isVisible: false,
            image: Assets.assetsImagesOnBoardingPage2ViewItem,
            backgroundimage:
                Assets.assetsImagesOnBoardingPage2ViewItemBackground,
            subtitle:
                'نقدم لك أفضل الفواكه المختارة بعناية. اطلع على التفاصيل والصور والتقييمات لتتأكد من اختيار الفاكهة المثالية',
            title: Text(
              'ابحث وتسوق',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0C0D0D),
                fontSize: 23,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
