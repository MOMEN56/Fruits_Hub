import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/on_boarding_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  bool get _usesNativeSplash =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(excuteNaviagtion);
  }

  @override
  Widget build(BuildContext context) {
    if (_usesNativeSplash) {
      return const ColoredBox(color: Colors.white);
    }

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

  void excuteNaviagtion() {
    if (!mounted) return;

    final isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    if (isOnBoardingViewSeen) {
      final isLoggedIn = FirebaseAuthService().isLoggedIn();

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, MainView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, SigninView.routeName);
      }
    } else {
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    }
  }
}
