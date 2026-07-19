// lib/presentation/widgets/media/helpers/placeholder_builder.dart

import 'package:flutter/material.dart';

import '../enums/image_placeholder.dart';

/// Builder class for creating image placeholders.
///
/// This class provides centralized placeholder generation for images.
///
/// Example:
/// ```dart
/// final placeholder = PlaceholderBuilder.build(
///   type: ImagePlaceholder.shimmer,
///   width: 100,
///   height: 100,
/// );
/// ```
abstract final class PlaceholderBuilder {
  /// Builds a placeholder widget with the given parameters.
  static Widget build({
    required ImagePlaceholder type,
    double? width,
    double? height,
    Color? color,
    Widget? customWidget,
  }) {
    switch (type) {
      case ImagePlaceholder.none:
        return const SizedBox.shrink();

      case ImagePlaceholder.shimmer:
        return _buildShimmer(width: width, height: height);

      case ImagePlaceholder.blur:
        return _buildBlur(width: width, height: height);

      case ImagePlaceholder.color:
        return _buildColor(width: width, height: height, color: color);

      case ImagePlaceholder.progress:
        return _buildProgress(width: width, height: height);

      case ImagePlaceholder.custom:
        return customWidget ?? const SizedBox.shrink();
    }
  }

  static Widget _buildShimmer({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.grey,
        ),
      ),
    );
  }

  static Widget _buildBlur({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.blur_on,
          color: Colors.grey,
        ),
      ),
    );
  }

  static Widget _buildColor({
    double? width,
    double? height,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static Widget _buildProgress({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
