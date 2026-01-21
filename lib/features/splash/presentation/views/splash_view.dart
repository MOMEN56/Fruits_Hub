import 'package:flutter/material.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';
import 'package:fruit_hub/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routeName = 'splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Executenavigation();
    super.initState();
  }

  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SplashViewBody()));
  }

  Executenavigation() {
    bool IsOnBoardingViewSeen = Prefs.getBool('KisOnBoardingViewSeen');
    Future.delayed(const Duration(seconds: 1), () {
      if (IsOnBoardingViewSeen == true) {
        Navigator.pushReplacementNamed(context, SigninView.routeName);
      } else
        Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    });
  }
}
