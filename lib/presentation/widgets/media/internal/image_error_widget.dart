// lib/presentation/widgets/media/internal/image_error_widget.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering image error state.
class ImageErrorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String? errorMessage;

  const ImageErrorWidget({
    super.key,
    this.width,
    this.height,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 32,
            color: Colors.grey.shade600,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
