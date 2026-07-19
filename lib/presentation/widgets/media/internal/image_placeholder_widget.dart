// lib/presentation/widgets/media/internal/image_placeholder_widget.dart

import 'package:flutter/material.dart';

import '../enums/image_placeholder.dart';
import '../helpers/placeholder_builder.dart';

/// Internal widget for rendering image placeholder.
class ImagePlaceholderWidget extends StatelessWidget {
  final ImagePlaceholder type;
  final double? width;
  final double? height;
  final Color? color;

  const ImagePlaceholderWidget({
    super.key,
    required this.type,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderBuilder.build(
      type: type,
      width: width,
      height: height,
      color: color,
    );
  }
}
