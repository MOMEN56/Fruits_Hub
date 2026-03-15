import 'package:flutter/widgets.dart';

abstract final class AppNavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
