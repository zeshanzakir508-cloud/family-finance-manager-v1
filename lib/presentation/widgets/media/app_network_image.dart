// lib/presentation/widgets/media/app_network_image.dart

import 'package:flutter/material.dart';

import 'enums/image_fit.dart';
import 'enums/image_shape.dart';
import 'enums/image_placeholder.dart';
import 'app_image.dart';

/// A network image widget with consistent styling.
///
/// This widget provides a standardized network image that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppNetworkImage(
///   url: 'https://example.com/photo.jpg',
///   fit: ImageFit.cover,
///   shape: ImageShape.circular,
///   width: 50,
///   height: 50,
/// )
/// ```
class AppNetworkImage extends StatelessWidget {
  /// The image URL.
  final String url;

  /// The fit behavior of the image.
  final ImageFit fit;

  /// The shape of the image.
  final ImageShape shape;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The placeholder type.
  final ImagePlaceholder placeholder;

  /// The placeholder color.
  final Color? placeholderColor;

  /// The error message to display.
  final String? errorMessage;

  /// The border radius for rounded images.
  final double borderRadius;

  /// The semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to fade in the image.
  final bool fadeIn;

  /// The cache duration.
  final Duration cacheDuration;

  /// Creates a new [AppNetworkImage].
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = ImageFit.cover,
    this.shape = ImageShape.rectangle,
    this.width,
    this.height,
    this.placeholder = ImagePlaceholder.shimmer,
    this.placeholderColor,
    this.errorMessage,
    this.borderRadius = 12,
    this.semanticLabel,
    this.fadeIn = true,
    this.cacheDuration = const Duration(days: 7),
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      image: NetworkImage(url),
      fit: fit,
      shape: shape,
      width: width,
      height: height,
      placeholder: placeholder,
      placeholderColor: placeholderColor,
      errorMessage: errorMessage,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
      fadeIn: fadeIn,
    );
  }
}
