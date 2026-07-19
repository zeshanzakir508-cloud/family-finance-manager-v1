// lib/presentation/widgets/buttons/helpers/button_text_style.dart

import 'package:flutter/material.dart';

import '../enums/app_button_size.dart';

/// Helper class for button text style calculations.
///
/// This class maps [AppButtonSize] to concrete [TextStyle] values
/// for consistent button typography across the application.
///
/// Example:
/// ```dart
/// final style = ButtonTextStyle.getTextStyle(context, AppButtonSize.medium);
/// ```
abstract final class ButtonTextStyle {
  /// Returns the [TextStyle] for the given [size].
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///   - [size]: The button size enum value.
  ///
  /// Returns:
  ///   The corresponding [TextStyle] for the button.
  static TextStyle getTextStyle(BuildContext context, AppButtonSize size) {
    final textTheme = Theme.of(context).textTheme;

    switch (size) {
      case AppButtonSize.extraSmall:
        return textTheme.labelSmall ?? const TextStyle(fontSize: 10);
      case AppButtonSize.small:
        return textTheme.labelMedium ?? const TextStyle(fontSize: 12);
      case AppButtonSize.medium:
        return textTheme.labelLarge ?? const TextStyle(fontSize: 14);
      case AppButtonSize.large:
        return textTheme.titleSmall ?? const TextStyle(fontSize: 16);
      case AppButtonSize.extraLarge:
        return textTheme.titleMedium ?? const TextStyle(fontSize: 18);
    }
  }
}
