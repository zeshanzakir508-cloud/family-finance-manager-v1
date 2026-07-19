// lib/presentation/widgets/feedback/helpers/loading_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/loading_size.dart';

/// Builder class for creating consistent loading styles.
///
/// This class constructs [LoadingStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for loading styling.
///
/// Example:
/// ```dart
/// final style = LoadingStyleBuilder.build(
///   size: LoadingSize.medium,
/// );
/// ```
abstract final class LoadingStyleBuilder {
  /// Builds a [LoadingStyle] configuration with the given parameters.
  static LoadingStyle build({
    required LoadingSize size,
  }) {
    double indicatorSize;
    double strokeWidth;

    switch (size) {
      case LoadingSize.small:
        indicatorSize = 24;
        strokeWidth = 2.5;
        break;

      case LoadingSize.medium:
        indicatorSize = 40;
        strokeWidth = 3.5;
        break;

      case LoadingSize.large:
        indicatorSize = 56;
        strokeWidth = 4.5;
        break;

      case LoadingSize.extraLarge:
        indicatorSize = 72;
        strokeWidth = 5.5;
        break;
    }

    return LoadingStyle(
      indicatorSize: indicatorSize,
      strokeWidth: strokeWidth,
    );
  }
}

/// Style configuration for loading indicators.
@immutable
class LoadingStyle {
  /// The size of the loading indicator.
  final double indicatorSize;

  /// The stroke width of the loading indicator.
  final double strokeWidth;

  /// Creates a new [LoadingStyle].
  const LoadingStyle({
    required this.indicatorSize,
    required this.strokeWidth,
  });
}
