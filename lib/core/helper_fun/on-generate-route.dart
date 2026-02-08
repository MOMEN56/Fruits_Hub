import 'package:flutter/material.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruit_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruit_hub/features/best_selling/presentation/view/best_selling_view.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case SigninView.routeName:
      return MaterialPageRoute(builder: (_) => const SigninView());
    case BestSellingView.routeName:
      return MaterialPageRoute(builder: (_) => const BestSellingView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case SignUpView.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpView());
    case MainView.routeName:
      return MaterialPageRoute(builder: (_) => const MainView());
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
