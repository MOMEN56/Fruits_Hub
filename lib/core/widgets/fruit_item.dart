import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/core/utils/assets.dart';

class FruitItem extends StatelessWidget {
  const FruitItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F5F7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_outline),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SvgPicture.asset(Assets.assetsImagesOnBoardingPage2ViewItem),
                  const SizedBox(height: 24),
                  ListTile(
                    title: const Text(
                      'بطيخ',
                      textAlign: TextAlign.right,
                      style: TextStyles.semiBold16,
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '30جنية ',
                            style: TextStyles.bold13.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '/',
                            style: TextStyles.bold13.copyWith(
                              color: AppColors.lightSecondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyles.semiBold13.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: 'الكيلو',
                            style: TextStyles.semiBold13.copyWith(
                              color: AppColors.lightSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
