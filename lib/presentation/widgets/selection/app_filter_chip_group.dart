// lib/presentation/widgets/selection/app_filter_chip_group.dart

import 'package:flutter/material.dart';

import '../chips/app_filter_chip.dart';
import '../chips/enums/chip_variant.dart';
import '../chips/enums/chip_size.dart';
import 'internal/selection_group.dart';

/// A group of filter chips for multiple selection.
///
/// This widget provides a standardized filter chip group that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppFilterChipGroup(
///   options: ['Income', 'Expense', 'Transfer'],
///   selected: selectedFilters,
///   onSelected: (value) => setState(() => selectedFilters = value),
/// )
/// ```
class AppFilterChipGroup<T> extends StatelessWidget {
  /// The list of options with their values.
  final List<FilterChipOption<T>> options;

  /// The currently selected values.
  final Set<T> selected;

  /// Callback when a chip selection changes.
  final ValueChanged<Set<T>>? onSelected;

  /// The visual variant of the chips.
  final ChipVariant variant;

  /// The size of the chips.
  final ChipSize chipSize;

  /// Whether the chips are disabled.
  final bool isDisabled;

  /// The direction of the chip group.
  final Axis direction;

  /// Creates a new [AppFilterChipGroup].
  const AppFilterChipGroup({
    super.key,
    required this.options,
    required this.selected,
    this.onSelected,
    this.variant = ChipVariant.filled,
    this.chipSize = ChipSize.medium,
    this.isDisabled = false,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionGroup(
      mode: SelectionMode.multiple,
      direction: direction,
      children: options.map((option) {
        final isSelected = selected.contains(option.value);
        return AppFilterChip(
          label: option.label,
          selected: isSelected,
          onSelected: isDisabled
              ? null
              : (value) {
                  final newSelected = Set<T>.from(selected);
                  if (value) {
                    newSelected.add(option.value);
                  } else {
                    newSelected.remove(option.value);
                  }
                  onSelected?.call(newSelected);
                },
          isDisabled: isDisabled,
          variant: variant,
          size: chipSize,
        );
      }).toList(),
    );
  }
}

/// A filter chip option.
class FilterChipOption<T> {
  /// The label text.
  final String label;

  /// The value.
  final T value;

  /// Creates a new [FilterChipOption].
  const FilterChipOption({
    required this.label,
    required this.value,
  });
}
