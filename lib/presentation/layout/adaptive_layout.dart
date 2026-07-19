// lib/presentation/layout/adaptive_layout.dart

import 'package:flutter/material.dart';

import 'layout_helpers.dart';

/// A widget that provides responsive layout with adaptive behavior.
///
/// This widget automatically adapts its layout based on screen size
/// without rebuilding the entire widget tree.
///
/// Example:
/// ```dart
/// AdaptiveLayout(
///   mobile: const MobileLayout(),
///   tablet: const TabletLayout(),
///   desktop: const DesktopLayout(),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  /// The widget to display on mobile devices.
  final Widget mobile;

  /// The widget to display on tablet devices.
  final Widget? tablet;

  /// The widget to display on desktop devices.
  final Widget? desktop;

  /// Creates a new [AdaptiveLayout].
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (LayoutHelpers.isMobile(context)) {
      return mobile;
    } else if (LayoutHelpers.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return desktop ?? tablet ?? mobile;
    }
  }
}
