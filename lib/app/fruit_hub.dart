import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fruit_hub/core/connectivity/connection_cubit.dart';
import 'package:fruit_hub/core/connectivity/connection_service.dart';
import 'package:fruit_hub/core/helper_fun/on-generate-route.dart';
import 'package:fruit_hub/core/services/app_navigation_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';
import 'package:fruit_hub/generated/l10n.dart';

class FruitHub extends StatelessWidget {
  const FruitHub({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectionCubit(getIt<ConnectionService>())..start(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: AppNavigationService.navigatorKey,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Cairo',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        ),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale('ar'),
        home: const SplashView(),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
