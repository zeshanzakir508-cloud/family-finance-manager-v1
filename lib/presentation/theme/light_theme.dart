// lib/presentation/theme/light_theme.dart

import 'package:flutter/material.dart';

import '../colors/app_color_palette.dart';
import '../typography/text_styles.dart';
import 'theme_builders.dart';
import 'theme_constants.dart';
import 'theme_extensions.dart';

/// Light theme implementation for the application.
///
/// This class builds the complete light theme configuration using shared
/// constants from [ThemeConstants] and the application's color palette.
///
/// Example:
/// ```dart
/// final theme = LightTheme.build();
/// ```
abstract final class LightTheme {
  /// Builds and returns the complete light theme configuration.
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(AppColorPalette.primary),
        onPrimary: Color(AppColorPalette.white),
        primaryContainer: Color(AppColorPalette.primaryLight),
        onPrimaryContainer: Color(AppColorPalette.primaryDark),
        secondary: Color(AppColorPalette.secondary),
        onSecondary: Color(AppColorPalette.white),
        secondaryContainer: Color(AppColorPalette.secondaryLight),
        onSecondaryContainer: Color(AppColorPalette.secondaryDark),
        tertiary: Color(AppColorPalette.accent),
        onTertiary: Color(AppColorPalette.white),
        tertiaryContainer: Color(AppColorPalette.accentLight),
        onTertiaryContainer: Color(AppColorPalette.accentDark),
        error: Color(AppColorPalette.error),
        onError: Color(AppColorPalette.white),
        errorContainer: Color(AppColorPalette.errorLight),
        onErrorContainer: Color(AppColorPalette.errorDark),
        surface: Color(AppColorPalette.white),
        onSurface: Color(AppColorPalette.gray900),
        surfaceVariant: Color(AppColorPalette.gray50),
        onSurfaceVariant: Color(AppColorPalette.gray700),
        outline: Color(AppColorPalette.gray400),
        outlineVariant: Color(AppColorPalette.gray300),
        shadow: Color(AppColorPalette.shadow),
        inverseSurface: Color(AppColorPalette.gray800),
        onInverseSurface: Color(AppColorPalette.white),
        inversePrimary: Color(AppColorPalette.primaryLight),
        surfaceTint: Color(AppColorPalette.primary),
      ),
      textTheme: TextStyles.lightTextTheme,
      primaryTextTheme: TextStyles.lightTextTheme,
      extensions: const [AppThemeExtension.light],
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
        const Color(AppColorPalette.gray50),
        const Color(AppColorPalette.gray300),
      ),
      chipTheme: ThemeBuilders.chipTheme(
        const Color(AppColorPalette.gray100),
        const Color(AppColorPalette.primaryLight),
        const Color(AppColorPalette.gray700),
      ),
    );
  }
}
