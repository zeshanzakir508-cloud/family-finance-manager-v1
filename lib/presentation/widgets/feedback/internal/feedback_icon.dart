// lib/presentation/widgets/feedback/internal/feedback_icon.dart

import 'package:flutter/material.dart';

import '../helpers/feedback_style_builder.dart';

/// Internal widget for rendering feedback icon.
class FeedbackIcon extends StatelessWidget {
  final FeedbackStyle style;
  final double size;

  const FeedbackIcon({
    super.key,
    required this.style,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.iconColor.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        style.iconData,
        color: style.iconColor,
        size: size * 0.5,
      ),
    );
  }
}
