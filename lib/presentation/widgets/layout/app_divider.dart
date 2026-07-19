// lib/presentation/widgets/layout/app_divider.dart

import 'package:flutter/material.dart';

import 'enums/divider_variant.dart';
import 'helpers/divider_style_builder.dart';

/// A divider with consistent styling.
///
/// This widget provides a standardized divider that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppDivider(
///   variant: DividerVariant.indented,
/// )
///
/// AppDivider.center(
///   label: 'or',
/// )
/// ```
class AppDivider extends StatelessWidget {
  /// The visual variant of the divider.
  final DividerVariant variant;

  /// The label text for center dividers.
  final String? label;

  /// Creates a new [AppDivider].
  const AppDivider({
    super.key,
    this.variant = DividerVariant.full,
    this.label,
  });

  /// Creates a center divider with a label.
  const AppDivider.center({
    super.key,
    required this.label,
  }) : variant = DividerVariant.center;

  @override
  Widget build(BuildContext context) {
    final style = DividerStyleBuilder.build(
      context: context,
      variant: variant,
    );

    if (variant == DividerVariant.center && label != null) {
      return Row(
        children: [
          Expanded(
            child: Divider(
              color: style.color,
              thickness: style.thickness,
              indent: style.indent,
              endIndent: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label!,
              style: style.labelStyle,
            ),
          ),
          Expanded(
            child: Divider(
              color: style.color,
              thickness: style.thickness,
              indent: 8,
              endIndent: style.endIndent,
            ),
          ),
        ],
      );
    }

    return Divider(
      color: style.color,
      thickness: style.thickness,
      indent: style.indent,
      endIndent: style.endIndent,
    );
  }
}
