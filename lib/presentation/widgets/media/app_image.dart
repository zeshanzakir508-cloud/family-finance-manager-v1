// lib/presentation/widgets/media/app_image.dart

import 'package:flutter/material.dart';

import 'enums/image_fit.dart';
import 'enums/image_shape.dart';
import 'enums/image_placeholder.dart';
import 'helpers/image_style_builder.dart';
import 'internal/image_frame.dart';
import 'internal/image_loading_widget.dart';
import 'internal/image_error_widget.dart';
import 'internal/image_placeholder_widget.dart';

/// A customizable image widget with consistent styling.
///
/// This widget provides a standardized image that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppImage(
///   image: AssetImage('assets/photo.jpg'),
///   fit: ImageFit.cover,
///   shape: ImageShape.rounded,
///   width: 100,
///   height: 100,
/// )
/// ```
class AppImage extends StatelessWidget {
  /// The image provider.
  final ImageProvider image;

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

  /// The fade-in duration.
  final Duration fadeDuration;

  /// Creates a new [AppImage].
  const AppImage({
    super.key,
    required this.image,
    this.fit = ImageFit.cover,
    this.shape = ImageShape.rectangle,
    this.width,
    this.height,
    this.placeholder = ImagePlaceholder.none,
    this.placeholderColor,
    this.errorMessage,
    this.borderRadius = 12,
    this.semanticLabel,
    this.fadeIn = true,
    this.fadeDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final style = ImageStyleBuilder.build(
      fit: fit,
      shape: shape,
      borderRadius: borderRadius,
    );

    return ImageFrame(
      style: style,
      width: width,
      height: height,
      child: FadeInImage(
        image: image,
        placeholder: MemoryImage(kTransparentImage),
        fit: fit.value,
        imageErrorBuilder: (context, error, stackTrace) {
          return ImageErrorWidget(
            width: width,
            height: height,
            errorMessage: errorMessage,
          );
        },
        fadeInDuration: fadeDuration,
        fadeOutDuration: fadeDuration,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
