// lib/presentation/widgets/media/internal/image_frame.dart

import 'package:flutter/material.dart';

import '../helpers/image_style_builder.dart';

/// Internal widget for rendering image frame.
class ImageFrame extends StatelessWidget {
  final Widget child;
  final ImageStyle style;
  final double? width;
  final double? height;

  const ImageFrame({
    super.key,
    required this.child,
    required this.style,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: style.borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
