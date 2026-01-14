import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/core/utils/assets.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SvgPicture.asset(Assets.assetsImagesFreepikPlantInject63)],
        ),

        SvgPicture.asset(Assets.assetsImagesAppLoge),
        SvgPicture.asset(
          Assets.assetsImagesBottomSplashScreen,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
