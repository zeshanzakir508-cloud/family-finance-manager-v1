// lib/presentation/theme/theme_constants.dart

import 'package:flutter/material.dart';

/// Shared design tokens used across light and dark themes.
///
/// This class centralizes all theme constants including spacing, border radius,
/// elevation, sizing, and other design tokens. It serves as the single source
/// of truth for all theme-related numeric values.
///
/// Example:
/// ```dart
/// final borderRadius = ThemeConstants.borderRadiusMedium;
/// final spacing = ThemeConstants.spacingLarge;
/// ```
abstract final class ThemeConstants {
  // ---------------------------------------------------------------------------
  // Border Radius
  // ---------------------------------------------------------------------------

  /// Small border radius (4px) - for chips, small elements.
  static const BorderRadiusGeometry borderRadiusSmall =
      BorderRadius.all(Radius.circular(4));

  /// Medium border radius (8px) - for buttons, inputs, cards.
  static const BorderRadiusGeometry borderRadiusMedium =
      BorderRadius.all(Radius.circular(8));

  /// Large border radius (12px) - for cards, dialogs.
  static const BorderRadiusGeometry borderRadiusLarge =
      BorderRadius.all(Radius.circular(12));

  /// Extra large border radius (16px) - for chips, tags.
  static const BorderRadiusGeometry borderRadiusXLarge =
      BorderRadius.all(Radius.circular(16));

  /// Pill border radius (50px) - for pills, badges.
  static const BorderRadiusGeometry borderRadiusPill =
      BorderRadius.all(Radius.circular(50));

  // ---------------------------------------------------------------------------
  // Elevation
  // ---------------------------------------------------------------------------

  /// No elevation.
  static const double elevationNone = 0;

  /// Small elevation (1) - for subtle shadows.
  static const double elevationSmall = 1;

  /// Medium elevation (2) - for cards, buttons.
  static const double elevationMedium = 2;

  /// Large elevation (4) - for dialogs, menus.
  static const double elevationLarge = 4;

  /// Extra large elevation (8) - for floating elements.
  static const double elevationXLarge = 8;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  /// Extra small spacing (4px).
  static const double spacingXS = 4;

  /// Small spacing (8px).
  static const double spacingSmall = 8;

  /// Medium spacing (12px).
  static const double spacingMedium = 12;

  /// Large spacing (16px).
  static const double spacingLarge = 16;

  /// Extra large spacing (24px).
  static const double spacingXLarge = 24;

  /// Double extra large spacing (32px).
  static const double spacingXXLarge = 32;

  // ---------------------------------------------------------------------------
  // Sizing
  // ---------------------------------------------------------------------------

  /// Minimum button height (48px) - accessible touch target.
  static const double buttonMinHeight = 48;

  /// Minimum button width (88px).
  static const double buttonMinWidth = 88;

  /// Input field height.
  static const double inputHeight = 56;

  /// Icon size small (16px).
  static const double iconSizeSmall = 16;

  /// Icon size medium (24px).
  static const double iconSizeMedium = 24;

  /// Icon size large (32px).
  static const double iconSizeLarge = 32;

  // ---------------------------------------------------------------------------
  // Shared Theme Configurations (Pure Constants)
  // ---------------------------------------------------------------------------

  /// Shared app bar theme configuration.
  static const AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: elevationNone,
    scrolledUnderElevation: elevationNone,
  );

  /// Shared card theme configuration.
  static const CardTheme cardTheme = CardTheme(
    elevation: elevationMedium,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadiusLarge,
    ),
  );

  /// Shared divider theme configuration.
  static const DividerThemeData dividerTheme = DividerThemeData(
    thickness: 1,
    space: spacingXLarge,
  );
}
