// lib/presentation/widgets/selection/internal/selection_label.dart

import 'package:flutter/material.dart';

import '../helpers/selection_style_builder.dart';

/// Internal widget for rendering selection label.
class SelectionLabel extends StatelessWidget {
  final String label;
  final SelectionStyle style;
  final bool disabled;

  const SelectionLabel({
    super.key,
    required this.label,
    required this.style,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: style.labelStyle.copyWith(
        color: disabled
            ? style.disabledColor
            : style.labelStyle.color,
      ),
    );
  }
}
