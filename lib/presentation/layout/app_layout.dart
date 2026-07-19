// lib/presentation/layout/app_layout.dart

/// Application layout design tokens.
///
/// This class defines the core layout system for the application,
/// including screen breakpoints, spacing, and responsive design values.
/// It serves as the single source of truth for all layout-related constants.
///
/// Example:
/// ```dart
/// final padding = AppLayout.paddingMedium;
/// final breakpoint = AppLayout.breakpointMobile;
/// ```
abstract final class AppLayout {
  // ---------------------------------------------------------------------------
  // Breakpoints
  // ---------------------------------------------------------------------------

  /// Maximum width for mobile devices (600px).
  static const double breakpointMobile = 600;

  /// Maximum width for tablet devices (1024px).
  static const double breakpointTablet = 1024;

  /// Minimum width for desktop devices (1025px+).
  static const double breakpointDesktop = 1025;

  // ---------------------------------------------------------------------------
  // Layout Constraints
  // ---------------------------------------------------------------------------

  /// Maximum content width for readability (1200px).
  static const double maxContentWidth = 1200;

  /// Maximum width for cards and containers (400px).
  static const double maxCardWidth = 400;

  /// Maximum width for forms (600px).
  static const double maxFormWidth = 600;

  // ---------------------------------------------------------------------------
  // Padding & Margins
  // ---------------------------------------------------------------------------

  /// Extra small padding (4px).
  static const double paddingXS = 4;

  /// Small padding (8px).
  static const double paddingSmall = 8;

  /// Medium padding (16px).
  static const double paddingMedium = 16;

  /// Large padding (24px).
  static const double paddingLarge = 24;

  /// Extra large padding (32px).
  static const double paddingXLarge = 32;

  /// Double extra large padding (48px).
  static const double paddingXXLarge = 48;

  // ---------------------------------------------------------------------------
  // Grid Defaults
  // ---------------------------------------------------------------------------

  /// Default grid spacing (16px).
  static const double defaultGridSpacing = paddingMedium;

  /// Default grid run spacing (16px).
  static const double defaultGridRunSpacing = paddingMedium;

  /// Default grid child aspect ratio (1.0).
  static const double defaultGridChildAspectRatio = 1.0;
}
