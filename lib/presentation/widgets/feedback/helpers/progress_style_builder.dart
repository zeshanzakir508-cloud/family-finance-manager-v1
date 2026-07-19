// lib/presentation/widgets/feedback/helpers/progress_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/progress_variant.dart';

/// Builder class for creating consistent progress styles.
///
/// This class constructs [ProgressStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for progress styling.
///
/// Example:
/// ```dart
/// final style = ProgressStyleBuilder.build(
///   variant: ProgressVariant.linear,
/// );
/// ```
abstract final class ProgressStyleBuilder {
  /// Builds a [ProgressStyle] configuration with the given parameters.
  static ProgressStyle build({
    required BuildContext context,
    required ProgressVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double height;
    double borderRadius;
    int segmentCount;

    switch (variant) {
      case ProgressVariant.linear:
        height = 4;
        borderRadius = 2;
        segmentCount = 0;
        break;

      case ProgressVariant.circular:
        height = 0;
        borderRadius = 0;
        segmentCount = 0;
        break;

      case ProgressVariant.segmented:
        height = 8;
        borderRadius = 4;
        segmentCount = 5;
        break;
    }

    return ProgressStyle(
      height: height,
      borderRadius: borderRadius,
      segmentCount: segmentCount,
      progressColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceVariant,
    );
  }
}

/// Style configuration for progress indicators.
@immutable
class ProgressStyle {
  /// The height of the progress indicator.
  final double height;

  /// The border radius of the progress indicator.
  final double borderRadius;

  /// The number of segments for segmented progress.
  final int segmentCount;

  /// The color of the progress.
  final Color progressColor;

  /// The background color of the progress.
  final Color backgroundColor;

  /// Creates a new [ProgressStyle].
  const ProgressStyle({
    required this.height,
    required this.borderRadius,
    required this.segmentCount,
    required this.progressColor,
    required this.backgroundColor,
  });
}
