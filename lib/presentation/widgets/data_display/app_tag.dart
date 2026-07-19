// lib/presentation/widgets/data_display/app_tag.dart

import 'package:flutter/material.dart';

import 'enums/label_position.dart';
import 'helpers/label_style_builder.dart';
import 'internal/data_label.dart';

/// A tag widget with consistent styling.
///
/// This widget provides a standardized tag that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppTag(
///   text: 'Premium',
///   variant: 'primary',
/// )
/// ```
class AppTag extends StatelessWidget {
  /// The tag text.
  final String text;

  /// The visual variant of the tag.
  final String variant;

  /// Creates a new [AppTag].
  const AppTag({
    super.key,
    required this.text,
    this.variant = 'neutral',
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
