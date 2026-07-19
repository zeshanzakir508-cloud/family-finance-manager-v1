// lib/presentation/widgets/feedback/app_progress_indicator.dart

import 'package:flutter/material.dart';

import 'enums/progress_variant.dart';
import 'helpers/progress_style_builder.dart';
import 'internal/progress_label.dart';

/// A progress indicator with consistent styling.
///
/// This widget provides a standardized progress indicator that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppProgressIndicator(
///   progress: 0.75,
///   variant: ProgressVariant.linear,
///   label: 'Loading',
/// )
/// ```
class AppProgressIndicator extends StatelessWidget {
  /// The progress value (0.0 to 1.0).
  final double progress;

  /// The visual variant of the progress indicator.
  final ProgressVariant variant;

  /// The optional label text.
  final String? label;

  /// Whether to show the percentage.
  final bool showPercentage;

  /// The color of the progress.
  final Color? progressColor;

  /// The background color of the progress.
  final Color? backgroundColor;

  /// Creates a new [AppProgressIndicator].
  const AppProgressIndicator({
    super.key,
    required this.progress,
    this.variant = ProgressVariant.linear,
    this.label,
    this.showPercentage = true,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = ProgressStyleBuilder.build(
      context: context,
      variant: variant,
    );

    final clampedProgress = progress.clamp(0.0, 1.0);
    final effectiveProgressColor = progressColor ?? style.progressColor;
    final effectiveBackgroundColor = backgroundColor ?? style.backgroundColor;

    final children = <Widget>[];

    if (variant == ProgressVariant.linear) {
      children.add(
        LinearProgressIndicator(
          value: clampedProgress,
          color: effectiveProgressColor,
          backgroundColor: effectiveBackgroundColor,
          minHeight: style.height,
          borderRadius: BorderRadius.circular(style.borderRadius),
        ),
      );
    } else if (variant == ProgressVariant.circular) {
      children.add(
        CircularProgressIndicator(
          value: clampedProgress,
          color: effectiveProgressColor,
          backgroundColor: effectiveBackgroundColor,
        ),
      );
    } else if (variant == ProgressVariant.segmented) {
      children.add(
        Row(
          children: List.generate(style.segmentCount, (index) {
            final isFilled = index / style.segmentCount < clampedProgress;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: style.height,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? effectiveProgressColor
                        : effectiveBackgroundColor,
                    borderRadius: BorderRadius.circular(style.borderRadius),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    children.add(
      ProgressLabel(
        progress: clampedProgress,
        label: label,
        showPercentage: showPercentage,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
