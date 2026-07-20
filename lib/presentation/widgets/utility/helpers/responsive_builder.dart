// lib/presentation/widgets/utility/helpers/responsive_builder.dart

import 'package:flutter/material.dart';

import '../enums/responsive_breakpoint.dart';

/// Helper class for responsive layout building.
///
/// This class provides methods for building responsive layouts
/// based on screen width.
///
/// Example:
/// ```dart
/// final layout = ResponsiveBuilder.getLayout(
///   context,
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
///   desktop: DesktopWidget(),
/// );
/// ```
abstract final class ResponsiveHelper {
  /// Returns the current responsive breakpoint.
  static ResponsiveBreakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ResponsiveBreakpoint.fromWidth(width);
  }

  /// Returns true if the current screen is mobile.
  static bool isMobile(BuildContext context) {
    return getBreakpoint(context) == ResponsiveBreakpoint.mobile;
  }

  /// Returns true if the current screen is tablet.
  static bool isTablet(BuildContext context) {
    return getBreakpoint(context) == ResponsiveBreakpoint.tablet;
  }

  /// Returns true if the current screen is desktop.
  static bool isDesktop(BuildContext context) {
    return getBreakpoint(context) == ResponsiveBreakpoint.desktop ||
        getBreakpoint(context) == ResponsiveBreakpoint.largeDesktop;
  }

  /// Returns true if the current screen is large desktop.
  static bool isLargeDesktop(BuildContext context) {
    return getBreakpoint(context) == ResponsiveBreakpoint.largeDesktop;
  }

  /// Returns the appropriate widget based on the current breakpoint.
  static Widget getLayout({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? largeDesktop,
  }) {
    final breakpoint = getBreakpoint(context);

    switch (breakpoint) {
      case ResponsiveBreakpoint.mobile:
        return mobile;
      case ResponsiveBreakpoint.tablet:
        return tablet ?? mobile;
      case ResponsiveBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
      case ResponsiveBreakpoint.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}
