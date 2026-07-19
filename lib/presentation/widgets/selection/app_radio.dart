// lib/presentation/widgets/selection/app_radio.dart

import 'package:flutter/material.dart';

import 'enums/selection_variant.dart';
import 'enums/selection_size.dart';
import 'enums/selection_state.dart';
import 'helpers/radio_style_builder.dart';
import 'internal/selection_control.dart';

/// A radio button widget with consistent styling.
///
/// This widget provides a standardized radio button that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppRadio(
///   value: selectedValue == 'option1',
///   onChanged: () => setState(() => selectedValue = 'option1'),
/// )
/// ```
class AppRadio extends StatelessWidget {
  /// Whether the radio is selected.
  final bool value;

  /// Callback when the radio is selected.
  final VoidCallback? onChanged;

  /// The visual variant of the radio.
  final SelectionVariant variant;

  /// The size of the radio.
  final SelectionSize size;

  /// Whether the radio is disabled.
  final bool disabled;

  /// Creates a new [AppRadio].
  const AppRadio({
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

    final style = RadioStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      state: state,
    );

    final isEnabled = !disabled && onChanged != null;

    return SelectionControl(
      state: state,
      style: SelectionStyle(
        activeColor: style.activeColor,
        inactiveColor: style.inactiveColor,
        disabledColor: style.disabledColor,
        size: style.size,
        iconSize: style.size * 0.5,
        labelStyle: const TextStyle(),
        borderRadius: BorderRadius.circular(style.size / 2),
      ),
      onTap: isEnabled ? onChanged : null,
      child: value
          ? Container(
              width: style.size * 0.4,
              height: style.size * 0.4,
              decoration: BoxDecoration(
                color: style.activeColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
