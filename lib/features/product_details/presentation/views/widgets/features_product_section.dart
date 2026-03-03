import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/feature_product_container.dart';

class FeaturesProductSection extends StatelessWidget {
  const FeaturesProductSection({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            FeatureProductContainer(
              title: '${productEntity.expirationsMonths} يوم',
              subtitle: 'الصلاحيه',
              icon: SvgPicture.asset(Assets.assetsImagesCalendar),
            ),
            const SizedBox(width: 16),
            FeatureProductContainer(
              title: '100%',
              subtitle: 'اوجانيك',
              icon: SvgPicture.asset(Assets.assetsImagesHand),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FeatureProductContainer(
              title: '${productEntity.numberOfCalories} كالوري',
              subtitle: '${productEntity.unitAmount} جرام',
              icon: SvgPicture.asset(Assets.assetsImagesCalorie),
            ),
            const SizedBox(width: 16),
            FeatureProductContainer(
              title: '4.8',
              subtitle: "التقييم",
              icon: SvgPicture.asset(Assets.assetsImagesFavourites),
            ),
          ],
        ),
      ],
    );
  }
}
