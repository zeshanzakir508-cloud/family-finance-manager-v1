// lib/presentation/widgets/buttons/segmented_button.dart

import 'package:flutter/material.dart';

import 'enums/app_button_size.dart';
import 'enums/app_toggle_selection.dart';
import 'builders/segmented_button_style_builder.dart';

/// A segmented button group for selecting between multiple options.
///
/// This widget provides a standardized segmented control that follows the
/// application's design system with support for multiple selection modes.
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
///   selectionType: AppToggleSelection.single,
///   size: AppButtonSize.medium,
/// )
/// ```
class AppSegmentedButton<T extends Object> extends StatelessWidget {
  /// The segments to display.
  final List<ButtonSegment<T>> segments;

  /// The selected value(s).
  final Set<T> selected;

  /// Callback when selection changes.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// The selection behavior of the segmented button.
  final AppToggleSelection selectionType;

  /// Whether empty selection is allowed.
  final bool allowEmptySelection;

  /// The size of the segmented button.
  final AppButtonSize size;

  /// Whether the segmented button is disabled.
  final bool isDisabled;

  /// The style to apply.
  final ButtonStyle? style;

  /// Creates a new [AppSegmentedButton].
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.selectionType = AppToggleSelection.single,
    this.allowEmptySelection = false,
    this.size = AppButtonSize.medium,
    this.isDisabled = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onSelectionChanged != null;

    final effectiveStyle = style ??
        SegmentedButtonStyleBuilder.build(
          context: context,
          size: size,
        );

    return MaterialSegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: isEnabled ? onSelectionChanged : null,
      style: effectiveStyle,
      showSelectedIcon: false,
      emptySelectionAllowed: allowEmptySelection,
      multiSelectionEnabled: selectionType == AppToggleSelection.multiple,
    );
  }
}

/// Alias for Flutter's SegmentedButton to avoid naming conflict.
typedef MaterialSegmentedButton<T extends Object> = SegmentedButton<T>;
