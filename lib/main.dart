import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/services/app_startup_service.dart';
import 'package:fruit_hub/core/services/custom_bloc_observer.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/core/services/supabase_services.dart';
import 'package:fruit_hub/app/fruit_hub.dart';
import 'firebase_runtime_options.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initSupabase();

  await Firebase.initializeApp(
    options: RuntimeFirebaseOptions.currentPlatform,
  );
  await Prefs.init();
  setupGetIt();
  AppStartupService.initialize();
  runApp(const FruitHub());
}
