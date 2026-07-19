// lib/presentation/widgets/feedback/internal/progress_label.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering progress label.
class ProgressLabel extends StatelessWidget {
  final double progress;
  final String? label;
  final bool showPercentage;

  const ProgressLabel({
    super.key,
    required this.progress,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).clamp(0, 100).toStringAsFixed(0);

    final text = label != null
        ? '$label: $percentage%'
        : showPercentage
            ? '$percentage%'
            : '';

    if (text.isEmpty) return const SizedBox.shrink();

    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
