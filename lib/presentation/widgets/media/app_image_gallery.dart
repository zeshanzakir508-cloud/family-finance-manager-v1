// lib/presentation/widgets/media/app_image_gallery.dart

import 'package:flutter/material.dart';
import 'package:interactive_viewer_gallery/interactive_viewer_gallery.dart';

import 'app_network_image.dart';
import 'enums/image_fit.dart';
import 'enums/image_shape.dart';

/// An image gallery widget for browsing multiple images.
///
/// This widget provides a standardized image gallery that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppImageGallery(
///   images: ['url1.jpg', 'url2.jpg', 'url3.jpg'],
/// )
/// ```
class AppImageGallery extends StatelessWidget {
  /// The list of image URLs.
  final List<String> images;

  /// The initial index to display.
  final int initialIndex;

  /// The background color of the gallery.
  final Color? backgroundColor;

  /// Creates a new [AppImageGallery].
  const AppImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.backgroundColor,
  });

  /// Shows the image gallery as a dialog.
  static Future<void> show(
    BuildContext context, {
    required List<String> images,
    int initialIndex = 0,
    Color? backgroundColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return AppImageGallery(
          images: images,
          initialIndex: initialIndex,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = backgroundColor ?? Colors.black;

    return Scaffold(
      backgroundColor: effectiveBackground,
      appBar: AppBar(
        backgroundColor: effectiveBackground,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InteractiveViewerGallery(
        images: images.map((url) {
          return AppNetworkImage(
            url: url,
            fit: ImageFit.contain,
            shape: ImageShape.rectangle,
          );
        }).toList(),
        initialIndex: initialIndex,
        itemBuilder: (context, index) {
          return images.isNotEmpty && index < images.length
              ? AppNetworkImage(
                  url: images[index],
                  fit: ImageFit.contain,
                  shape: ImageShape.rectangle,
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
