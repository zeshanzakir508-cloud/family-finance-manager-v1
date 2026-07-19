// lib/presentation/widgets/selection/app_checkbox.dart

import 'package:flutter/material.dart';

import 'enums/selection_variant.dart';
import 'enums/selection_size.dart';
import 'enums/selection_state.dart';
import 'helpers/checkbox_style_builder.dart';
import 'internal/selection_control.dart';

/// A checkbox widget with consistent styling.
///
/// This widget provides a standardized checkbox that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppCheckbox(
///   value: isChecked,
///   onChanged: (value) => setState(() => isChecked = value),
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  /// The current value of the checkbox.
  final bool value;

  /// Callback when the checkbox value changes.
  final ValueChanged<bool>? onChanged;

  /// The visual variant of the checkbox.
  final SelectionVariant variant;

  /// The size of the checkbox.
  final SelectionSize size;

  /// Whether the checkbox is disabled.
  final bool disabled;

  /// Creates a new [AppCheckbox].
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.variant = SelectionVariant.primary,
    this.size = SelectionSize.medium,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = disabled
        ? SelectionState.disabled
        : value
            ? SelectionState.selected
            : SelectionState.unselected;

    final style = CheckboxStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      state: state,
    );

    final isEnabled = !disabled && onChanged != null;

    return SelectionControl(
      state: state,
      style: SelectionStyle(
        activeColor: style.fillColor,
        inactiveColor: style.borderColor,
        disabledColor: style.borderColor,
        size: style.size,
        iconSize: style.size * 0.6,
        labelStyle: const TextStyle(),
        borderRadius: style.borderRadius,
      ),
      onTap: isEnabled ? () => onChanged!(!value) : null,
      child: value
          ? Icon(
              Icons.check,
              color: style.checkColor,
              size: style.size * 0.6,
            )
          : null,
    );
  }
}
