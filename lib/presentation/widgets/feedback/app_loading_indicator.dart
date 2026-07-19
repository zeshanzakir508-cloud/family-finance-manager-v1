// lib/presentation/widgets/feedback/app_loading_indicator.dart

import 'package:flutter/material.dart';

import 'enums/loading_size.dart';
import 'helpers/loading_style_builder.dart';
import 'internal/loading_content.dart';

/// A loading indicator with consistent styling.
///
/// This widget provides a standardized loading indicator that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppLoadingIndicator(
///   size: LoadingSize.medium,
///   label: 'Loading transactions...',
/// )
/// ```
class AppLoadingIndicator extends StatelessWidget {
  /// The size of the loading indicator.
  final LoadingSize size;

  /// The optional label text.
  final String? label;

  /// The color of the loading indicator.
  final Color? color;

  /// Creates a new [AppLoadingIndicator].
  const AppLoadingIndicator({
    super.key,
    this.size = LoadingSize.medium,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = LoadingStyleBuilder.build(size: size);
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return LoadingContent(
      style: style,
      color: effectiveColor,
      label: label,
    );
  }
}
