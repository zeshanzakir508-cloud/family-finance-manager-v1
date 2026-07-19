// lib/presentation/widgets/buttons/app_toggle_button.dart

import 'package:flutter/material.dart';

import 'enums/app_button_size.dart';
import 'constants/button_constants.dart';

/// A toggle switch with consistent styling.
///
/// This widget provides a standardized toggle switch that follows the
/// application's design system with support for multiple sizes.
///
/// Example:
/// ```dart
/// AppToggleSwitch(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
///   label: 'Enable Feature',
///   size: AppButtonSize.medium,
/// )
/// ```
class AppToggleSwitch extends StatelessWidget {
  /// The current value of the toggle.
  final bool value;

  /// Callback when the toggle value changes.
  final ValueChanged<bool>? onChanged;

  /// The label text.
  final String label;

  /// The size of the toggle switch.
  final AppButtonSize size;

  /// Whether the toggle is disabled.
  final bool isDisabled;

  /// Creates a new [AppToggleSwitch].
  const AppToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = !isDisabled && onChanged != null;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: value,
          onChanged: isEnabled ? onChanged : null,
          activeColor: colorScheme.primary,
          materialTapTargetSize: _getTapTargetSize(),
        ),
        const SizedBox(width: ButtonConstants.iconTextSpacing),
        Text(
          label,
          style: _getTextStyle(textTheme).copyWith(
            color: isEnabled
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  MaterialTapTargetSize _getTapTargetSize() {
    switch (size) {
      case AppButtonSize.extraSmall:
      case AppButtonSize.small:
        return MaterialTapTargetSize.shrinkWrap;
      case AppButtonSize.medium:
      case AppButtonSize.large:
      case AppButtonSize.extraLarge:
        return MaterialTapTargetSize.padded;
    }
  }

  TextStyle _getTextStyle(TextTheme textTheme) {
    switch (size) {
      case AppButtonSize.extraSmall:
        return textTheme.labelSmall!;
      case AppButtonSize.small:
        return textTheme.labelMedium!;
      case AppButtonSize.medium:
        return textTheme.bodyMedium!;
      case AppButtonSize.large:
        return textTheme.bodyLarge!;
      case AppButtonSize.extraLarge:
        return textTheme.titleMedium!;
    }
  }
}
