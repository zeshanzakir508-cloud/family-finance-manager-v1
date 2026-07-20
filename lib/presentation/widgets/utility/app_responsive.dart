// lib/presentation/widgets/utility/app_responsive.dart

import 'package:flutter/material.dart';

import 'enums/responsive_breakpoint.dart';
import 'helpers/responsive_builder.dart';
import 'internal/responsive_scope.dart';

/// A responsive widget that adapts to screen size.
///
/// This widget provides a standardized responsive layout that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppResponsive(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
///   desktop: DesktopWidget(),
/// )
/// ```
class AppResponsive extends StatelessWidget {
  /// The widget for mobile devices.
  final Widget mobile;

  /// The widget for tablet devices.
  final Widget? tablet;

  /// The widget for desktop devices.
  final Widget? desktop;

  /// The widget for large desktop devices.
  final Widget? largeDesktop;

  /// Whether to provide the breakpoint to descendants.
  final bool provideScope;

  /// Creates a new [AppResponsive].
  const AppResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.provideScope = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = ResponsiveHelper.getLayout(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );

    if (provideScope) {
      final breakpoint = ResponsiveHelper.getBreakpoint(context);
      final size = MediaQuery.of(context).size;
      return ResponsiveScope(
        breakpoint: breakpoint,
        size: size,
        child: child,
      );
    }

    return child;
  }
}
