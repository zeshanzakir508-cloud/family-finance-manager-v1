// lib/presentation/widgets/selection/app_switch.dart

import 'package:flutter/material.dart';

import 'enums/selection_variant.dart';
import 'enums/selection_size.dart';

/// A switch widget with consistent styling.
///
/// This widget provides a standardized switch that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSwitch(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
/// )
/// ```
class AppSwitch extends StatelessWidget {
  /// The current value of the switch.
  final bool value;

  /// Callback when the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// The visual variant of the switch.
  final SelectionVariant variant;

  /// The size of the switch.
  final SelectionSize size;

  /// Whether the switch is disabled.
  final bool disabled;

  /// Creates a new [AppSwitch].
  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.variant = SelectionVariant.primary,
    this.size = SelectionSize.medium,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color activeColor;
    Color inactiveColor;

    switch (variant) {
      case SelectionVariant.primary:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        break;
      case SelectionVariant.secondary:
        activeColor = colorScheme.secondary;
        inactiveColor = colorScheme.surfaceVariant;
        break;
      case SelectionVariant.success:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        break;
      case SelectionVariant.warning:
        activeColor = colorScheme.tertiary;
        inactiveColor = colorScheme.surfaceVariant;
        break;
      case SelectionVariant.error:
        activeColor = colorScheme.error;
        inactiveColor = colorScheme.surfaceVariant;
        break;
      case SelectionVariant.neutral:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        break;
    }

    return Switch(
      value: value,
      onChanged: disabled ? null : onChanged,
      activeColor: activeColor,
      inactiveThumbColor: inactiveColor,
      inactiveTrackColor: inactiveColor,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
