// lib/presentation/widgets/data_display/app_data_label.dart

import 'package:flutter/material.dart';

import 'enums/label_position.dart';
import 'helpers/label_style_builder.dart';
import 'internal/data_label.dart';

/// A data label widget with consistent styling.
///
/// This widget provides a standardized data label that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppDataLabel(
///   text: 'Income',
///   variant: 'success',
/// )
/// ```
class AppDataLabel extends StatelessWidget {
  /// The label text.
  final String text;

  /// The visual variant of the label.
  final String variant;

  /// The position of the label.
  final LabelPosition position;

  /// Creates a new [AppDataLabel].
  const AppDataLabel({
    super.key,
    required this.text,
    this.variant = 'neutral',
    this.position = LabelPosition.left,
  });

  @override
  Widget build(BuildContext context) {
    final style = LabelStyleBuilder.build(
      context: context,
      variant: variant,
    );

    return DataLabel(
      text: text,
      variant: variant,
      style: style,
    );
  }
}
