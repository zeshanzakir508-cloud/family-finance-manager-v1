// lib/presentation/widgets/feedback/internal/loading_content.dart

import 'package:flutter/material.dart';

import '../helpers/loading_style_builder.dart';

/// Internal widget for rendering loading content.
class LoadingContent extends StatelessWidget {
  final LoadingStyle style;
  final Color color;
  final String? label;

  const LoadingContent({
    super.key,
    required this.style,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      SizedBox(
        height: style.indicatorSize,
        width: style.indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: style.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    ];

    if (label != null && label!.isNotEmpty) {
      children.add(const SizedBox(height: 16));
      children.add(
        Text(
          label!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
