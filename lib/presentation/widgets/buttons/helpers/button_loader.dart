// lib/presentation/widgets/buttons/helpers/button_loader.dart

import 'package:flutter/material.dart';

import '../constants/button_constants.dart';

/// Helper class for button loading indicator configuration.
///
/// This class provides consistent loading indicator styling
/// for buttons across the application.
///
/// Example:
/// ```dart
/// final loader = ButtonLoader.getLoader(
///   foregroundColor: Colors.white,
///   size: ButtonConstants.loadingIndicatorSize,
/// );
/// ```
abstract final class ButtonLoader {
  /// Returns a loading indicator widget with the given [foregroundColor].
  ///
  /// Parameters:
  ///   - [foregroundColor]: The color of the loading indicator.
  ///   - [size]: The size of the loading indicator. Defaults to
  ///     [ButtonConstants.loadingIndicatorSize].
  ///   - [strokeWidth]: The stroke width of the loading indicator.
  ///     Defaults to [ButtonConstants.loadingIndicatorStrokeWidth].
  ///
  /// Returns:
  ///   A [CircularProgressIndicator] configured with the given parameters.
  static Widget getLoader({
    required Color foregroundColor,
    double size = ButtonConstants.loadingIndicatorSize,
    double strokeWidth = ButtonConstants.loadingIndicatorStrokeWidth,
  }) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
      ),
    );
  }

  /// Returns a loading indicator with default configuration.
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///
  /// Returns:
  ///   A [CircularProgressIndicator] configured with default values.
  static Widget getDefaultLoader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return getLoader(
      foregroundColor: colorScheme.onPrimary,
    );
  }
}
