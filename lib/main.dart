import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fruit_hub/core/helper_fun/on-generate-route.dart';
import 'package:fruit_hub/core/services/custom_bloc_observer.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/services/subabase_services.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/features/splash/presentation/views/splash_view.dart';
import 'package:fruit_hub/generated/l10n.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'firebase_options.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initSupabase();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Prefs.init();
  setupGitIt();
  runApp(const FruitHub());
}

class FruitHub extends StatelessWidget {
  const FruitHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: SplashView(),
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
