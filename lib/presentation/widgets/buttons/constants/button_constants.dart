// lib/presentation/widgets/buttons/constants/button_constants.dart

import 'package:flutter/material.dart';

/// Centralized constants for all button-related design values.
///
/// This class contains only pure constants - no methods or logic.
/// All values are used across button helpers, builders, and widgets.
///
/// Example:
/// ```dart
/// final height = ButtonConstants.heightMedium;
/// final radius = ButtonConstants.radiusRounded;
/// ```
abstract final class ButtonConstants {
  // ---------------------------------------------------------------------------
  // Heights
  // ---------------------------------------------------------------------------

  /// Height for extra small buttons (28px).
  static const double heightExtraSmall = 28;

  /// Height for small buttons (32px).
  static const double heightSmall = 32;

  /// Height for medium buttons (40px).
  static const double heightMedium = 40;

  /// Height for large buttons (48px).
  static const double heightLarge = 48;

  /// Height for extra large buttons (56px).
  static const double heightExtraLarge = 56;

  // ---------------------------------------------------------------------------
  // Icon Sizes
  // ---------------------------------------------------------------------------

  /// Icon size for extra small buttons (14px).
  static const double iconSizeExtraSmall = 14;

  /// Icon size for small buttons (16px).
  static const double iconSizeSmall = 16;

  /// Icon size for medium buttons (20px).
  static const double iconSizeMedium = 20;

  /// Icon size for large buttons (24px).
  static const double iconSizeLarge = 24;

  /// Icon size for extra large buttons (28px).
  static const double iconSizeExtraLarge = 28;

  // ---------------------------------------------------------------------------
  // Padding
  // ---------------------------------------------------------------------------

  /// Horizontal padding for extra small buttons (8px).
  static const double paddingHorizontalExtraSmall = 8;

  /// Horizontal padding for small buttons (12px).
  static const double paddingHorizontalSmall = 12;

  /// Horizontal padding for medium buttons (16px).
  static const double paddingHorizontalMedium = 16;

  /// Horizontal padding for large buttons (20px).
  static const double paddingHorizontalLarge = 20;

  /// Horizontal padding for extra large buttons (24px).
  static const double paddingHorizontalExtraLarge = 24;

  /// Vertical padding for extra small buttons (2px).
  static const double paddingVerticalExtraSmall = 2;

  /// Vertical padding for small buttons (4px).
  static const double paddingVerticalSmall = 4;

  /// Vertical padding for medium buttons (8px).
  static const double paddingVerticalMedium = 8;

  /// Vertical padding for large buttons (10px).
  static const double paddingVerticalLarge = 10;

  /// Vertical padding for extra large buttons (12px).
  static const double paddingVerticalExtraLarge = 12;

  // ---------------------------------------------------------------------------
  // Border Radius
  // ---------------------------------------------------------------------------

  /// Border radius for rounded buttons (8px).
  static const double radiusRounded = 8;

  /// Border radius for pill buttons (50px).
  static const double radiusPill = 50;

  /// Border radius for square buttons (0px).
  static const double radiusSquare = 0;

  /// Border radius for circular buttons (9999px - effectively infinite).
  static const double radiusCircular = 9999;

  // ---------------------------------------------------------------------------
  // Elevation
  // ---------------------------------------------------------------------------

  /// Default elevation for filled buttons (2px).
  static const double elevationDefault = 2;

  /// Elevation for elevated buttons (4px).
  static const double elevationElevated = 4;

  /// No elevation (0px).
  static const double elevationNone = 0;

  // ---------------------------------------------------------------------------
  // Animation
  // ---------------------------------------------------------------------------

  /// Default animation duration (300ms).
  static const Duration animationDuration = Duration(milliseconds: 300);

  // ---------------------------------------------------------------------------
  // Loading Indicator
  // ---------------------------------------------------------------------------

  /// Loading indicator size (20px).
  static const double loadingIndicatorSize = 20;

  /// Loading indicator stroke width (2px).
  static const double loadingIndicatorStrokeWidth = 2;

  // ---------------------------------------------------------------------------
  // Border
  // ---------------------------------------------------------------------------

  /// Default border width (1px).
  static const double borderWidthDefault = 1;

  // ---------------------------------------------------------------------------
  // Minimum Width
  // ---------------------------------------------------------------------------

  /// Minimum width for buttons (64px).
  static const double minWidth = 64;

  // ---------------------------------------------------------------------------
  // FAB Sizes
  // ---------------------------------------------------------------------------

  /// Small FAB diameter (40px).
  static const double fabSizeSmall = 40;

  /// Regular FAB diameter (56px).
  static const double fabSizeRegular = 56;

  /// Large FAB diameter (64px).
  static const double fabSizeLarge = 64;

  /// Extended FAB height (48px).
  static const double fabExtendedHeight = 48;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  /// Space between icon and text (8px).
  static const double iconTextSpacing = 8;

  /// Space between buttons in a group (4px).
  static const double groupSpacing = 4;

  // ---------------------------------------------------------------------------
  // Disabled State
  // ---------------------------------------------------------------------------

  /// Opacity for disabled buttons (0.38).
  static const double disabledOpacity = 0.38;

  /// Opacity for disabled container (0.12).
  static const double disabledContainerOpacity = 0.12;
}
