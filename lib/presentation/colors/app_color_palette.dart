// lib/presentation/colors/app_color_palette.dart

/// A palette that defines the core color system for the application.
///
/// This class serves as the single source of truth for all base color
/// definitions used across the app. It provides a comprehensive set of
/// reusable colors that can be referenced throughout the presentation layer.
///
/// All colors are defined as [int] values (ARGB) to maintain consistency
/// and avoid dependency on Flutter's [Color] class at this layer.
///
/// Example:
/// ```dart
/// final primaryColor = AppColorPalette.primary;
/// final accentColor = AppColorPalette.accent;
/// ```
abstract final class AppColorPalette {
  // ---------------------------------------------------------------------------
  // Brand Colors
  // ---------------------------------------------------------------------------

  /// Primary brand color - used for main actions and navigation.
  static const int primary = 0xFF2196F3;

  /// Primary brand color (dark variant) - used for hover, pressed states.
  static const int primaryDark = 0xFF1976D2;

  /// Primary brand color (light variant) - used for backgrounds, chips.
  static const int primaryLight = 0xFFBBDEFB;

  /// Secondary brand color - used for complementary UI elements.
  static const int secondary = 0xFFFF9800;

  /// Secondary brand color (dark variant).
  static const int secondaryDark = 0xFFF57C00;

  /// Secondary brand color (light variant).
  static const int secondaryLight = 0xFFFFE0B2;

  /// Accent color - used for highlights and CTAs.
  static const int accent = 0xFFE91E63;

  /// Accent color (dark variant).
  static const int accentDark = 0xFFC2185B;

  /// Accent color (light variant).
  static const int accentLight = 0xFFF8BBD0;

  // ---------------------------------------------------------------------------
  // Neutral Colors
  // ---------------------------------------------------------------------------

  /// Pure white.
  static const int white = 0xFFFFFFFF;

  /// Lightest gray - used for backgrounds and cards.
  static const int gray50 = 0xFFFAFAFA;

  /// Very light gray.
  static const int gray100 = 0xFFF5F5F5;

  /// Light gray.
  static const int gray200 = 0xFFEEEEEE;

  /// Medium light gray.
  static const int gray300 = 0xFFE0E0E0;

  /// Medium gray - used for borders and dividers.
  static const int gray400 = 0xFFBDBDBD;

  /// Base gray.
  static const int gray500 = 0xFF9E9E9E;

  /// Medium dark gray - used for secondary text.
  static const int gray600 = 0xFF757575;

  /// Dark gray - used for primary text.
  static const int gray700 = 0xFF616161;

  /// Very dark gray.
  static const int gray800 = 0xFF424242;

  /// Almost black.
  static const int gray900 = 0xFF212121;

  /// Pure black.
  static const int black = 0xFF000000;

  // ---------------------------------------------------------------------------
  // Semantic Colors
  // ---------------------------------------------------------------------------

  /// Success color - used for positive actions, completed states.
  static const int success = 0xFF4CAF50;

  /// Success color (dark variant).
  static const int successDark = 0xFF388E3C;

  /// Success color (light variant).
  static const int successLight = 0xFFC8E6C9;

  /// Error color - used for destructive actions, errors.
  static const int error = 0xFFF44336;

  /// Error color (dark variant).
  static const int errorDark = 0xFFD32F2F;

  /// Error color (light variant).
  static const int errorLight = 0xFFFFCDD2;

  /// Warning color - used for caution, pending states.
  static const int warning = 0xFFFFC107;

  /// Warning color (dark variant).
  static const int warningDark = 0xFFFFA000;

  /// Warning color (light variant).
  static const int warningLight = 0xFFFFECB3;

  /// Info color - used for informational messages.
  static const int info = 0xFF2196F3;

  /// Info color (dark variant).
  static const int infoDark = 0xFF1976D2;

  /// Info color (light variant).
  static const int infoLight = 0xFFBBDEFB;

  // ---------------------------------------------------------------------------
  // Gradient Definitions
  // ---------------------------------------------------------------------------

  /// Primary gradient start color.
  static const int gradientStart = 0xFF2196F3;

  /// Primary gradient end color.
  static const int gradientEnd = 0xFF1565C0;

  /// Secondary gradient start color.
  static const int gradientSecondaryStart = 0xFFFF9800;

  /// Secondary gradient end color.
  static const int gradientSecondaryEnd = 0xFFE65100;
}
