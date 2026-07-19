// lib/presentation/widgets/media/app_asset_image.dart

import 'package:flutter/material.dart';

import 'enums/image_fit.dart';
import 'enums/image_shape.dart';
import 'enums/image_placeholder.dart';
import 'app_image.dart';

/// An asset image widget with consistent styling.
///
/// This widget provides a standardized asset image that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppAssetImage(
///   asset: 'assets/icons/logo.png',
///   fit: ImageFit.contain,
///   width: 100,
///   height: 100,
/// )
/// ```
class AppAssetImage extends StatelessWidget {
  /// The asset path.
  final String asset;

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

  /// Creates a new [AppAssetImage].
  const AppAssetImage({
    super.key,
    required this.asset,
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
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      image: AssetImage(asset),
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
