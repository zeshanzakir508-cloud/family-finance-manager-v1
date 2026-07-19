// lib/presentation/theme/theme_builders.dart

import 'package:flutter/material.dart';

import '../colors/app_color_palette.dart';
import 'theme_constants.dart';

/// Factory class for building theme components.
///
/// This class provides reusable builder methods that construct theme
/// components for both light and dark themes, eliminating code duplication.
///
/// Example:
/// ```dart
/// final buttonTheme = ThemeBuilders.elevatedButtonTheme(
///   Colors.blue,
/// );
/// ```
abstract final class ThemeBuilders {
  /// Creates an elevated button theme with the given [backgroundColor].
  static ElevatedButtonThemeData elevatedButtonTheme(
    Color backgroundColor,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(
          ThemeConstants.buttonMinWidth,
          ThemeConstants.buttonMinHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.borderRadiusMedium,
        ),
      ),
    );
  }

  /// Creates an outlined button theme with the given [foregroundColor].
  static OutlinedButtonThemeData outlinedButtonTheme(
    Color foregroundColor,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        minimumSize: const Size(
          ThemeConstants.buttonMinWidth,
          ThemeConstants.buttonMinHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.borderRadiusMedium,
        ),
      ),
    );
  }

  /// Creates a text button theme with the given [foregroundColor].
  static TextButtonThemeData textButtonTheme(Color foregroundColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        minimumSize: const Size(
          ThemeConstants.buttonMinWidth,
          ThemeConstants.buttonMinHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.borderRadiusMedium,
        ),
      ),
    );
  }

  /// Creates an input decoration theme with the given [fillColor] and [borderColor].
  static InputDecorationTheme inputDecorationTheme(
    Color fillColor,
    Color borderColor,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingLarge,
        vertical: ThemeConstants.spacingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: ThemeConstants.borderRadiusMedium,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ThemeConstants.borderRadiusMedium,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ThemeConstants.borderRadiusMedium,
        borderSide: const BorderSide(
          color: Color(AppColorPalette.primary),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: ThemeConstants.borderRadiusMedium,
        borderSide: const BorderSide(
          color: Color(AppColorPalette.error),
          width: 2,
        ),
      ),
    );
  }

  /// Creates a chip theme with the given [backgroundColor], [selectedColor], and [labelColor].
  static ChipThemeData chipTheme(
    Color backgroundColor,
    Color selectedColor,
    Color labelColor,
  ) {
    return ChipThemeData(
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      labelStyle: TextStyle(color: labelColor),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingMedium,
        vertical: ThemeConstants.spacingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusPill,
      ),
    );
  }
}
