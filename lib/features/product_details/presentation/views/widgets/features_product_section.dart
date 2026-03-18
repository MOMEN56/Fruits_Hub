import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub/core/entities/product_entity.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/generated/l10n.dart';
import 'package:fruit_hub/features/product_details/presentation/views/widgets/feature_product_container.dart';

class FeaturesProductSection extends StatelessWidget {
  const FeaturesProductSection({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasTwoColumns = constraints.maxWidth >= 280;
        final itemWidth =
            hasTwoColumns ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            FeatureProductContainer(
              width: itemWidth,
              title: l10n.days(productEntity.expirationsMonths.toString()),
              subtitle: l10n.expiry,
              icon: SvgPicture.asset(Assets.assetsImagesCalendar),
            ),
            FeatureProductContainer(
              width: itemWidth,
              title: '100%',
              subtitle: l10n.organic,
              icon: SvgPicture.asset(Assets.assetsImagesHand),
            ),
            FeatureProductContainer(
              width: itemWidth,
              title: l10n.calories(productEntity.numberOfCalories.toString()),
              subtitle: l10n.grams(productEntity.unitAmount.toString()),
              icon: SvgPicture.asset(Assets.assetsImagesCalorie),
            ),
            FeatureProductContainer(
              width: itemWidth,
              title: '4.8',
              subtitle: l10n.rating,
              icon: SvgPicture.asset(Assets.assetsImagesFavourites),
            ),
          ],
        );
      },
    );
  }
}
