// lib/presentation/widgets/selection/app_segmented_button.dart

import 'package:flutter/material.dart';

import '../buttons/app_segmented_button.dart';
import '../buttons/enums/app_button_size.dart';
import '../buttons/enums/app_toggle_selection.dart';

/// A segmented button widget with consistent styling.
///
/// This widget provides a standardized segmented button that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSegmentedButton<String>(
///   segments: [
///     ButtonSegment(value: 'day', label: Text('Day')),
///     ButtonSegment(value: 'week', label: Text('Week')),
///     ButtonSegment(value: 'month', label: Text('Month')),
///   ],
///   selected: selectedPeriod,
///   onSelectionChanged: (value) => setState(() => selectedPeriod = value),
/// )
/// ```
class AppSegmentedButton<T extends Object> extends StatelessWidget {
  /// The segments to display.
  final List<ButtonSegment<T>> segments;

  /// The selected value(s).
  final Set<T> selected;

  /// Callback when selection changes.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// The selection behavior.
  final AppToggleSelection selectionType;

  /// The size of the segmented button.
  final AppButtonSize size;

  /// Whether the segmented button is disabled.
  final bool isDisabled;

  /// The style to apply.
  final ButtonStyle? style;

  /// Whether empty selection is allowed.
  final bool allowEmptySelection;

  /// Creates a new [AppSegmentedButton].
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.selectionType = AppToggleSelection.single,
    this.size = AppButtonSize.medium,
    this.isDisabled = false,
    this.style,
    this.allowEmptySelection = false,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      selectionType: selectionType,
      size: size,
      isDisabled: isDisabled,
      style: style,
      allowEmptySelection: allowEmptySelection,
    );
  }
}
