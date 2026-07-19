// lib/presentation/layout/responsive_builder.dart

import 'package:flutter/material.dart';

import 'layout_helpers.dart';

/// A widget that builds different layouts based on screen size.
///
/// This widget uses the builder pattern to provide different widget trees
/// for mobile, tablet, and desktop screen sizes.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context) => MobileHomePage(),
///   tablet: (context) => TabletHomePage(),
///   desktop: (context) => DesktopHomePage(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// The widget to display on mobile devices.
  final Widget Function(BuildContext context) mobile;

  /// The widget to display on tablet devices.
  final Widget Function(BuildContext context)? tablet;

  /// The widget to display on desktop devices.
  final Widget Function(BuildContext context)? desktop;

  /// Creates a new [ResponsiveBuilder].
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (LayoutHelpers.isMobile(context)) {
      return mobile(context);
    } else if (LayoutHelpers.isTablet(context)) {
      return tablet?.call(context) ?? mobile(context);
    } else {
      return desktop?.call(context) ?? tablet?.call(context) ?? mobile(context);
    }
  }
}
