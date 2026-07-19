// lib/presentation/widgets/selection/app_choice_chip_group.dart

import 'package:flutter/material.dart';

import '../chips/app_choice_chip.dart';
import '../chips/enums/chip_variant.dart';
import '../chips/enums/chip_size.dart';
import 'internal/selection_group.dart';

/// A group of choice chips for single selection.
///
/// This widget provides a standardized choice chip group that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppChoiceChipGroup(
///   options: ['Weekly', 'Monthly', 'Yearly'],
///   selected: 'Monthly',
///   onSelected: (value) => setState(() => selected = value),
/// )
/// ```
class AppChoiceChipGroup<T> extends StatelessWidget {
  /// The list of options with their values.
  final List<ChoiceChipOption<T>> options;

  /// The currently selected value.
  final T? selected;

  /// Callback when a chip is selected.
  final ValueChanged<T>? onSelected;

  /// The visual variant of the chips.
  final ChipVariant variant;

  /// The size of the chips.
  final ChipSize chipSize;

  /// Whether the chips are disabled.
  final bool isDisabled;

  /// The direction of the chip group.
  final Axis direction;

  /// Creates a new [AppChoiceChipGroup].
  const AppChoiceChipGroup({
    super.key,
    required this.options,
    this.selected,
    this.onSelected,
    this.variant = ChipVariant.filled,
    this.chipSize = ChipSize.medium,
    this.isDisabled = false,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionGroup(
      mode: SelectionMode.single,
      direction: direction,
      children: options.map((option) {
        final isSelected = selected == option.value;
        return AppChoiceChip(
          label: option.label,
          selected: isSelected,
          onSelected: isDisabled ? null : () => onSelected?.call(option.value),
          isDisabled: isDisabled,
          variant: variant,
          size: chipSize,
        );
      }).toList(),
    );
  }
}

/// A choice chip option.
class ChoiceChipOption<T> {
  /// The label text.
  final String label;

  /// The value.
  final T value;

  /// Creates a new [ChoiceChipOption].
  const ChoiceChipOption({
    required this.label,
    required this.value,
  });
}
