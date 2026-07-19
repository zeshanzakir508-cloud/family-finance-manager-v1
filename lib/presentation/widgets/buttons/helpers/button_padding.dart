// lib/presentation/widgets/buttons/helpers/button_padding.dart

import 'package:flutter/material.dart';

import '../enums/app_button_size.dart';
import '../constants/button_constants.dart';

/// Helper class for button padding calculations.
///
/// This class maps [AppButtonSize] to concrete [EdgeInsets] values
/// for consistent button spacing across the application.
///
/// Example:
/// ```dart
/// final padding = ButtonPadding.getPadding(AppButtonSize.medium);
/// ```
abstract final class ButtonPadding {
  /// Returns the [EdgeInsets] for the given [size].
  ///
  /// Parameters:
  ///   - [size]: The button size enum value.
  ///
  /// Returns:
  ///   The corresponding [EdgeInsets] for the button.
  static EdgeInsets getPadding(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.extraSmall:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.paddingHorizontalExtraSmall,
          vertical: ButtonConstants.paddingVerticalExtraSmall,
        );
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.paddingHorizontalSmall,
          vertical: ButtonConstants.paddingVerticalSmall,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.paddingHorizontalMedium,
          vertical: ButtonConstants.paddingVerticalMedium,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.paddingHorizontalLarge,
          vertical: ButtonConstants.paddingVerticalLarge,
        );
      case AppButtonSize.extraLarge:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.paddingHorizontalExtraLarge,
          vertical: ButtonConstants.paddingVerticalExtraLarge,
        );
    }
  }
}
