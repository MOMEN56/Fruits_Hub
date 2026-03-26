import 'package:flutter/widgets.dart';

abstract final class AppNavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final ValueNotifier<int> mainViewTabNotifier = ValueNotifier(0);

  static void setMainViewTab(int index) {
    if (mainViewTabNotifier.value == index) return;
    mainViewTabNotifier.value = index;
  }
}
