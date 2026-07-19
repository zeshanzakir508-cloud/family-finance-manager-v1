// lib/presentation/widgets/selection/internal/selection_control.dart

import 'package:flutter/material.dart';

import '../enums/selection_state.dart';
import '../helpers/selection_style_builder.dart';

/// Internal widget for rendering selection control (checkbox/radio).
class SelectionControl extends StatelessWidget {
  final SelectionState state;
  final SelectionStyle style;
  final VoidCallback? onTap;
  final Widget child;

  const SelectionControl({
    super.key,
    required this.state,
    required this.style,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = state == SelectionState.disabled;

    Widget control = Container(
      width: style.size,
      height: style.size,
      decoration: BoxDecoration(
        color: style.activeColor,
        borderRadius: style.borderRadius,
      ),
      child: child,
    );

    if (onTap != null && !isDisabled) {
      control = InkWell(
        onTap: onTap,
        borderRadius: style.borderRadius,
        child: control,
      );
    }

    return control;
  }
}
