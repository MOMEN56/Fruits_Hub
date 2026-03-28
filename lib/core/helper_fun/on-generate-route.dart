import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruit_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruit_hub/features/best_selling/presentation/view/best_selling_view.dart';
import 'package:fruit_hub/features/checkout/presentation/views/checkout_view.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:fruit_hub/features/notifications/presentation/views/notifications_view.dart';
import 'package:fruit_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruit_hub/features/admin/orders/presentation/views/orders_view.dart';
import 'package:fruit_hub/features/product_details/presentation/views/product_details_view.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case SigninView.routeName:
      return MaterialPageRoute(builder: (_) => const SigninView());
    case ProductDetailsView.routeName:
      final args = settings.arguments as ProductDetailsArgs;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: args.cartCubit,
          child: ProductDetailsView(productEntity: args.productEntity),
        ),
      );
    case BestSellingView.routeName:
      final args = settings.arguments as BestSellingViewArgs;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: args.cartCubit,
          child: const BestSellingView(),
        ),
      );
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case SignUpView.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpView());
    case MainView.routeName:
      final initialViewIndex =
          settings.arguments is int ? settings.arguments as int : 0;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CartCubit(),
          child: MainView(initialViewIndex: initialViewIndex),
        ),
      );
    case CheckoutView.routeName:
      final args = settings.arguments as CheckoutArgs;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: args.cartCubit,
          child: CheckoutView(cartEntity: args.cartEntity),
        ),
      );
    case OrdersView.routeName:
      return MaterialPageRoute(builder: (_) => const OrdersView());
    case NotificationsView.routeName:
      final args = settings.arguments;
      final viewArgs =
          args is NotificationsViewArgs ? args : const NotificationsViewArgs();
      return MaterialPageRoute(
        builder: (_) => NotificationsView(args: viewArgs),
      );
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
