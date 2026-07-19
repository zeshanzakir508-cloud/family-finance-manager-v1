// lib/presentation/widgets/media/app_zoomable_image.dart

import 'package:flutter/material.dart';
import 'package:interactive_viewer_gallery/interactive_viewer_gallery.dart';

import 'app_image.dart';
import 'enums/image_fit.dart';
import 'enums/image_shape.dart';

/// A zoomable image widget with consistent styling.
///
/// This widget provides a standardized zoomable image that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppZoomableImage(
///   url: 'https://example.com/photo.jpg',
///   width: 300,
///   height: 300,
/// )
/// ```
class AppZoomableImage extends StatelessWidget {
  /// The image URL.
  final String? url;

  /// The image provider.
  final ImageProvider? imageProvider;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The minimum scale.
  final double minScale;

  /// The maximum scale.
  final double maxScale;

  /// Creates a new [AppZoomableImage].
  const AppZoomableImage({
    super.key,
    this.url,
    this.imageProvider,
    this.width,
    this.height,
    this.minScale = 0.8,
    this.maxScale = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final image = url != null
        ? AppNetworkImage(
            url: url!,
            fit: ImageFit.contain,
            shape: ImageShape.rectangle,
          )
        : imageProvider != null
            ? AppImage(
                image: imageProvider!,
                fit: ImageFit.contain,
                shape: ImageShape.rectangle,
              )
            : const SizedBox.shrink();

    return InteractiveViewer(
      minScale: minScale,
      maxScale: maxScale,
      child: SizedBox(
        width: width,
        height: height,
        child: image,
      ),
    );
  }
}
