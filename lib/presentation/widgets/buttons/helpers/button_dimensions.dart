// lib/presentation/widgets/buttons/helpers/button_dimensions.dart

import 'package:flutter/material.dart';

import '../enums/app_button_size.dart';
import '../constants/button_constants.dart';

/// Helper class for button dimension calculations.
///
/// This class maps [AppButtonSize] to concrete dimension values
/// such as height and icon size.
///
/// Example:
/// ```dart
/// final height = ButtonDimensions.getHeight(AppButtonSize.medium);
/// final iconSize = ButtonDimensions.getIconSize(AppButtonSize.small);
/// ```
abstract final class ButtonDimensions {
  /// Returns the height in pixels for the given [size].
  ///
  /// Parameters:
  ///   - [size]: The button size enum value.
  ///
  /// Returns:
  ///   The corresponding height in pixels.
  static double getHeight(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.extraSmall:
        return ButtonConstants.heightExtraSmall;
      case AppButtonSize.small:
        return ButtonConstants.heightSmall;
      case AppButtonSize.medium:
        return ButtonConstants.heightMedium;
      case AppButtonSize.large:
        return ButtonConstants.heightLarge;
      case AppButtonSize.extraLarge:
        return ButtonConstants.heightExtraLarge;
    }
  }

  /// Returns the icon size in pixels for the given [size].
  ///
  /// Parameters:
  ///   - [size]: The button size enum value.
  ///
  /// Returns:
  ///   The corresponding icon size in pixels.
  static double getIconSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.extraSmall:
        return ButtonConstants.iconSizeExtraSmall;
      case AppButtonSize.small:
        return ButtonConstants.iconSizeSmall;
      case AppButtonSize.medium:
        return ButtonConstants.iconSizeMedium;
      case AppButtonSize.large:
        return ButtonConstants.iconSizeLarge;
      case AppButtonSize.extraLarge:
        return ButtonConstants.iconSizeExtraLarge;
    }
  }
}
