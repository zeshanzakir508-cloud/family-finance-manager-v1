// lib/presentation/widgets/media/helpers/image_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/image_fit.dart';
import '../enums/image_shape.dart';

/// Builder class for creating consistent image styles.
///
/// This class constructs [ImageStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for image styling.
///
/// Example:
/// ```dart
/// final style = ImageStyleBuilder.build(
///   fit: ImageFit.cover,
///   shape: ImageShape.rounded,
/// );
/// ```
abstract final class ImageStyleBuilder {
  /// Builds an [ImageStyle] configuration with the given parameters.
  static ImageStyle build({
    required ImageFit fit,
    required ImageShape shape,
    double borderRadius = 12,
  }) {
    double effectiveBorderRadius;

    switch (shape) {
      case ImageShape.rectangle:
        effectiveBorderRadius = 0;
        break;
      case ImageShape.rounded:
        effectiveBorderRadius = borderRadius;
        break;
      case ImageShape.circular:
        effectiveBorderRadius = 9999;
        break;
      case ImageShape.square:
        effectiveBorderRadius = 0;
        break;
    }

    return ImageStyle(
      fit: fit.value,
      shape: shape,
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
    );
  }
}

/// Style configuration for images.
@immutable
class ImageStyle {
  /// The fit behavior of the image.
  final BoxFit fit;

  /// The shape of the image.
  final ImageShape shape;

  /// The border radius of the image.
  final BorderRadius borderRadius;

  /// Creates a new [ImageStyle].
  const ImageStyle({
    required this.fit,
    required this.shape,
    required this.borderRadius,
  });
}
