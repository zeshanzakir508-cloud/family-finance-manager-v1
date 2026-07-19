// lib/presentation/widgets/buttons/helpers/button_radius.dart

import 'package:flutter/material.dart';

import '../enums/app_button_shape.dart';
import '../constants/button_constants.dart';

/// Helper class for button radius calculations.
///
/// This class maps [AppButtonShape] to concrete [BorderRadius] values
/// for consistent button corner rounding across the application.
///
/// Example:
/// ```dart
/// final radius = ButtonRadius.getRadius(AppButtonShape.rounded);
/// ```
abstract final class ButtonRadius {
  /// Returns the [BorderRadius] for the given [shape].
  ///
  /// Parameters:
  ///   - [shape]: The button shape enum value.
  ///
  /// Returns:
  ///   The corresponding [BorderRadius] for the button.
  static BorderRadius getRadius(AppButtonShape shape) {
    switch (shape) {
      case AppButtonShape.rounded:
        return BorderRadius.circular(ButtonConstants.radiusRounded);
      case AppButtonShape.pill:
        return BorderRadius.circular(ButtonConstants.radiusPill);
      case AppButtonShape.square:
        return BorderRadius.circular(ButtonConstants.radiusSquare);
      case AppButtonShape.circular:
        return BorderRadius.circular(ButtonConstants.radiusCircular);
    }
  }
}
