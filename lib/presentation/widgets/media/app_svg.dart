// lib/presentation/widgets/media/app_svg.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'enums/image_fit.dart';
import 'enums/image_shape.dart';
import 'helpers/image_style_builder.dart';
import 'internal/image_frame.dart';

/// An SVG image widget with consistent styling.
///
/// This widget provides a standardized SVG image that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSvg(
///   asset: 'assets/icons/icon.svg',
///   width: 24,
///   height: 24,
///   color: Colors.blue,
/// )
/// ```
class AppSvg extends StatelessWidget {
  /// The asset path for the SVG.
  final String asset;

  /// The color to apply to the SVG.
  final Color? color;

  /// The width of the SVG.
  final double? width;

  /// The height of the SVG.
  final double? height;

  /// The fit behavior of the SVG.
  final ImageFit fit;

  /// The shape of the SVG.
  final ImageShape shape;

  /// The border radius for rounded shapes.
  final double borderRadius;

  /// The semantic label for accessibility.
  final String? semanticLabel;

  /// Creates a new [AppSvg].
  const AppSvg({
    super.key,
    required this.asset,
    this.color,
    this.width,
    this.height,
    this.fit = ImageFit.contain,
    this.shape = ImageShape.rectangle,
    this.borderRadius = 12,
    this.semanticLabel,
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
      child: SvgPicture.asset(
        asset,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        width: width,
        height: height,
        fit: fit.value,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
