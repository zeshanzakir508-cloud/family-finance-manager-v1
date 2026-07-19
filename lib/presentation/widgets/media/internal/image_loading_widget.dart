// lib/presentation/widgets/media/internal/image_loading_widget.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering image loading state.
class ImageLoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const ImageLoadingWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
