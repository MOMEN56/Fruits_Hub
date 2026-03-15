import 'package:flutter/material.dart';

class ResponsiveLayout {
  const ResponsiveLayout._();

  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < tabletBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopBreakpoint;
  }

  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16;
  }

  static int productsGridCount(double availableWidth) {
    // `availableWidth` is the grid width after screen padding, so keep the
    // single-column fallback only for very narrow devices.
    if (availableWidth < 280) return 1;
    if (availableWidth < 920) return 2;
    if (availableWidth < 1300) return 3;
    return 4;
  }
}
