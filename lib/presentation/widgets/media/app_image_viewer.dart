// lib/presentation/widgets/media/app_image_viewer.dart

import 'package:flutter/material.dart';

import 'app_image.dart';
import 'enums/image_fit.dart';
import 'enums/image_shape.dart';

/// An image viewer widget for full-screen image display.
///
/// This widget provides a standardized image viewer that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppImageViewer.show(
///   context,
///   imageUrl: 'https://example.com/photo.jpg',
/// )
/// ```
class AppImageViewer extends StatelessWidget {
  /// The image URL or asset path.
  final String? imageUrl;

  /// The image provider.
  final ImageProvider? imageProvider;

  /// The background color of the viewer.
  final Color? backgroundColor;

  /// The hero tag for hero animations.
  final String? heroTag;

  /// Creates a new [AppImageViewer].
  const AppImageViewer({
    super.key,
    this.imageUrl,
    this.imageProvider,
    this.backgroundColor,
    this.heroTag,
  });

  /// Shows the image viewer as a dialog.
  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
    Color? backgroundColor,
    String? heroTag,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return AppImageViewer(
          imageUrl: imageUrl,
          backgroundColor: backgroundColor,
          heroTag: heroTag,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = backgroundColor ?? Colors.black;

    final imageWidget = imageUrl != null
        ? AppNetworkImage(
            url: imageUrl!,
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

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: effectiveBackground,
        child: Center(
          child: heroTag != null
              ? Hero(
                  tag: heroTag!,
                  child: imageWidget,
                )
              : imageWidget,
        ),
      ),
    );
  }
}
