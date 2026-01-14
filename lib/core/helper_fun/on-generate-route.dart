import 'package:flutter/material.dart';
import 'package:fruit_hub/features/auth/presentation/views/login_view.dart';
import 'package:fruit_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (_) => const LoginView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case SignUpView.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpView());
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
