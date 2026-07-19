// lib/presentation/widgets/media/app_blurred_image.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'app_image.dart';
import 'enums/image_fit.dart';
import 'enums/image_shape.dart';

/// A blurred image widget with consistent styling.
///
/// This widget provides a standardized blurred image that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppBlurredImage(
///   url: 'https://example.com/photo.jpg',
///   blurAmount: 10,
///   width: 300,
///   height: 200,
/// )
/// ```
class AppBlurredImage extends StatelessWidget {
  /// The image URL.
  final String? url;

  /// The image provider.
  final ImageProvider? imageProvider;

  /// The blur amount.
  final double blurAmount;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The fit behavior of the image.
  final ImageFit fit;

  /// The shape of the image.
  final ImageShape shape;

  /// Creates a new [AppBlurredImage].
  const AppBlurredImage({
    super.key,
    this.url,
    this.imageProvider,
    this.blurAmount = 10,
    this.width,
    this.height,
    this.fit = ImageFit.cover,
    this.shape = ImageShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final image = url != null
        ? AppNetworkImage(
            url: url!,
            fit: fit,
            shape: shape,
          )
        : imageProvider != null
            ? AppImage(
                image: imageProvider!,
                fit: fit,
                shape: shape,
              )
            : const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: image,
        ),
      ),
    );
  }
}
