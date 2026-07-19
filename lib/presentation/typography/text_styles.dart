// lib/presentation/typography/text_styles.dart

import 'package:flutter/material.dart';

import 'typography.dart';

/// Application-wide text style definitions.
///
/// This class defines the complete set of text styles used throughout the
/// application, including light and dark theme variants. It uses the
/// typography design tokens from [Typography] for consistency.
///
/// Example:
/// ```dart
/// final headlineStyle = TextStyles.headlineLarge;
/// final bodyStyle = TextStyles.bodyMedium;
/// ```
abstract final class TextStyles {
  // ---------------------------------------------------------------------------
  // Base Text Styles
  // ---------------------------------------------------------------------------

  /// Display large text style.
  static const TextStyle displayLarge = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.displayLargeSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightTight,
  );

  /// Display medium text style.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.displayMediumSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightTight,
  );

  /// Display small text style.
  static const TextStyle displaySmall = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.displaySmallSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightTight,
  );

  /// Headline large text style.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.headlineLargeSize,
    fontWeight: Typography.weightBold,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightNormal,
  );

  /// Headline medium text style.
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.headlineMediumSize,
    fontWeight: Typography.weightBold,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightNormal,
  );

  /// Headline small text style.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.headlineSmallSize,
    fontWeight: Typography.weightSemiBold,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightNormal,
  );

  /// Title large text style.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.titleLargeSize,
    fontWeight: Typography.weightMedium,
    letterSpacing: Typography.letterSpacingNone,
    height: Typography.lineHeightNormal,
  );

  /// Title medium text style.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.titleMediumSize,
    fontWeight: Typography.weightSemiBold,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightNormal,
  );

  /// Title small text style.
  static const TextStyle titleSmall = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.titleSmallSize,
    fontWeight: Typography.weightMedium,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightNormal,
  );

  /// Body large text style.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.bodyLargeSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightRelaxed,
  );

  /// Body medium text style.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.bodyMediumSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightRelaxed,
  );

  /// Body small text style.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.bodySmallSize,
    fontWeight: Typography.weightRegular,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightRelaxed,
  );

  /// Label large text style.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.labelLargeSize,
    fontWeight: Typography.weightMedium,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightNormal,
  );

  /// Label medium text style.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.labelMediumSize,
    fontWeight: Typography.weightMedium,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightNormal,
  );

  /// Label small text style.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: Typography.fontFamily,
    fontSize: Typography.labelSmallSize,
    fontWeight: Typography.weightMedium,
    letterSpacing: Typography.letterSpacingLoose,
    height: Typography.lineHeightNormal,
  );

  // ---------------------------------------------------------------------------
  // Light Theme Text Theme
  // ---------------------------------------------------------------------------

  /// Light theme text theme configuration.
  static TextTheme get lightTextTheme {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  // ---------------------------------------------------------------------------
  // Dark Theme Text Theme
  // ---------------------------------------------------------------------------

  /// Dark theme text theme configuration.
  ///
  /// Currently uses the same styles as light theme since typography
  /// should remain consistent across themes. Color contrast is handled
  /// by the theme's color scheme.
  static TextTheme get darkTextTheme {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
