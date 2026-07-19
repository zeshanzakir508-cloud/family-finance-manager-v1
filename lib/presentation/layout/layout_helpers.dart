// lib/presentation/layout/layout_helpers.dart

import 'package:flutter/material.dart';

import 'app_layout.dart';

/// Helper functions for responsive layout calculations.
///
/// This class provides utility methods for determining screen sizes,
/// responsive padding, and other layout calculations based on the
/// current context.
///
/// Example:
/// ```dart
/// if (LayoutHelpers.isMobile(context)) {
///   // Mobile layout
/// }
/// ```
abstract final class LayoutHelpers {
  /// Returns true if the current screen width is mobile-sized.
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppLayout.breakpointMobile;
  }

  /// Returns true if the current screen width is tablet-sized.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppLayout.breakpointMobile &&
        width < AppLayout.breakpointTablet;
  }

  /// Returns true if the current screen width is desktop-sized.
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppLayout.breakpointTablet;
  }

  /// Returns the appropriate padding based on screen size.
  static EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppLayout.breakpointMobile) {
      return const EdgeInsets.all(AppLayout.paddingMedium);
    } else if (width < AppLayout.breakpointTablet) {
      return const EdgeInsets.all(AppLayout.paddingLarge);
    } else {
      return const EdgeInsets.all(AppLayout.paddingXLarge);
    }
  }

  /// Returns the appropriate max width for content containers.
  static double responsiveMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > AppLayout.maxContentWidth) {
      return AppLayout.maxContentWidth;
    }
    return width - AppLayout.paddingXLarge * 2;
  }

  /// Returns the number of grid columns based on screen size.
  static int getGridColumnCount(
    BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppLayout.breakpointMobile) {
      return mobileColumns;
    } else if (width < AppLayout.breakpointTablet) {
      return tabletColumns;
    } else {
      return desktopColumns;
    }
  }
}
