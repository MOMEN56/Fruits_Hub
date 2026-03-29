import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/core/utils/assets.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';
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
    Future<void>.microtask(_executeNavigation);
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

  Future<void> _executeNavigation() async {
    final isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    if (!isOnBoardingViewSeen) {
      _navigateTo(OnBoardingView.routeName);
      return;
    }

    final cachedUser = getIt<CurrentUserService>().getCurrentUser();
    if (cachedUser != null) {
      _navigateTo(MainView.routeName);
      return;
    }

    final restoredUser = await getIt<FirebaseAuthService>().restoreSessionUser();
    if (restoredUser != null) {
      await _ensureCurrentUserCache(restoredUser);
      _navigateTo(MainView.routeName);
      return;
    }

    _navigateTo(SigninView.routeName);
  }

  Future<void> _ensureCurrentUserCache(User restoredUser) async {
    final currentUserService = getIt<CurrentUserService>();
    if (currentUserService.getCurrentUserId() != null) {
      return;
    }

    try {
      final storedUser = await getIt<AuthRepo>().getUserData(
        uid: restoredUser.uid,
      ).timeout(const Duration(seconds: 2));
      await currentUserService.saveCurrentUser(storedUser);
      return;
    } catch (_) {}

    await currentUserService.saveFirebaseUser(restoredUser);
  }

  void _navigateTo(String routeName) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, routeName);
  }
}
