// lib/presentation/widgets/media/helpers/image_cache_builder.dart

import 'package:flutter/material.dart';

/// Builder class for image cache configuration.
///
/// This class provides centralized image cache settings.
///
/// Example:
/// ```dart
/// final cache = ImageCacheBuilder.build(
///   width: 200,
///   height: 200,
///   quality: ImageQuality.medium,
/// );
/// ```
abstract final class ImageCacheBuilder {
  /// Builds cache configuration with the given parameters.
  static ImageCacheConfig build({
    int? width,
    int? height,
    Duration cacheDuration = const Duration(days: 7),
  }) {
    return ImageCacheConfig(
      width: width,
      height: height,
      cacheDuration: cacheDuration,
    );
  }
}

/// Image cache configuration.
@immutable
class ImageCacheConfig {
  /// The width to cache.
  final int? width;

  /// The height to cache.
  final int? height;

  /// The cache duration.
  final Duration cacheDuration;

  /// Creates a new [ImageCacheConfig].
  const ImageCacheConfig({
    this.width,
    this.height,
    this.cacheDuration = const Duration(days: 7),
  });
}
