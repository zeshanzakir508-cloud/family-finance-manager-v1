// lib/presentation/widgets/media/enums/image_fit.dart

import 'package:flutter/material.dart';

/// The fit behavior of the image.
enum ImageFit {
  /// Fill the entire container (may crop).
  fill,

  /// Cover the container while maintaining aspect ratio (may crop).
  cover,

  /// Contain the image within the container (may have empty space).
  contain,

  /// Fit the image to the container width (may have empty space vertically).
  fitWidth,

  /// Fit the image to the container height (may have empty space horizontally).
  fitHeight,

  /// No scaling (image may overflow).
  none;

  /// Returns the Flutter [BoxFit] for this enum value.
  BoxFit get value {
    switch (this) {
      case ImageFit.fill:
        return BoxFit.fill;
      case ImageFit.cover:
        return BoxFit.cover;
      case ImageFit.contain:
        return BoxFit.contain;
      case ImageFit.fitWidth:
        return BoxFit.fitWidth;
      case ImageFit.fitHeight:
        return BoxFit.fitHeight;
      case ImageFit.none:
        return BoxFit.none;
    }
  }
}
