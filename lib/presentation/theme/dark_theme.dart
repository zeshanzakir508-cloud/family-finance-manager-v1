// lib/presentation/theme/dark_theme.dart

import 'package:flutter/material.dart';

import '../colors/app_color_palette.dart';
import '../typography/text_styles.dart';
import 'theme_builders.dart';
import 'theme_constants.dart';
import 'theme_extensions.dart';

/// Dark theme implementation for the application.
///
/// This class builds the complete dark theme configuration using shared
/// constants from [ThemeConstants] and the application's color palette.
///
/// Example:
/// ```dart
/// final theme = DarkTheme.build();
/// ```
abstract final class DarkTheme {
  /// Builds and returns the complete dark theme configuration.
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(AppColorPalette.primary),
        onPrimary: Color(AppColorPalette.white),
        primaryContainer: Color(AppColorPalette.primaryDark),
        onPrimaryContainer: Color(AppColorPalette.primaryLight),
        secondary: Color(AppColorPalette.secondary),
        onSecondary: Color(AppColorPalette.white),
        secondaryContainer: Color(AppColorPalette.secondaryDark),
        onSecondaryContainer: Color(AppColorPalette.secondaryLight),
        tertiary: Color(AppColorPalette.accent),
        onTertiary: Color(AppColorPalette.white),
        tertiaryContainer: Color(AppColorPalette.accentDark),
        onTertiaryContainer: Color(AppColorPalette.accentLight),
        error: Color(AppColorPalette.error),
        onError: Color(AppColorPalette.white),
        errorContainer: Color(AppColorPalette.errorDark),
        onErrorContainer: Color(AppColorPalette.errorLight),
        surface: Color(AppColorPalette.gray900),
        onSurface: Color(AppColorPalette.gray50),
        surfaceVariant: Color(AppColorPalette.gray800),
        onSurfaceVariant: Color(AppColorPalette.gray300),
        outline: Color(AppColorPalette.gray600),
        outlineVariant: Color(AppColorPalette.gray700),
        shadow: Color(AppColorPalette.shadow),
        inverseSurface: Color(AppColorPalette.gray50),
        onInverseSurface: Color(AppColorPalette.gray900),
        inversePrimary: Color(AppColorPalette.primaryLight),
        surfaceTint: Color(AppColorPalette.primary),
      ),
      textTheme: TextStyles.darkTextTheme,
      primaryTextTheme: TextStyles.darkTextTheme,
      extensions: const [AppThemeExtension.dark],
      appBarTheme: ThemeConstants.appBarTheme,
      cardTheme: ThemeConstants.cardTheme,
      dividerTheme: ThemeConstants.dividerTheme,
      elevatedButtonTheme: ThemeBuilders.elevatedButtonTheme(
        const Color(AppColorPalette.primary),
      ),
      outlinedButtonTheme: ThemeBuilders.outlinedButtonTheme(
        const Color(AppColorPalette.primary),
      ),
      textButtonTheme: ThemeBuilders.textButtonTheme(
        const Color(AppColorPalette.primary),
      ),
      inputDecorationTheme: ThemeBuilders.inputDecorationTheme(
        const Color(AppColorPalette.gray800),
        const Color(AppColorPalette.gray700),
      ),
      chipTheme: ThemeBuilders.chipTheme(
        const Color(AppColorPalette.gray800),
        const Color(AppColorPalette.primaryDark),
        const Color(AppColorPalette.gray300),
      ),
    );
  }
}
