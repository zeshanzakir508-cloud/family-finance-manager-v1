// lib/presentation/widgets/selection/app_selection_group.dart

import 'package:flutter/material.dart';

import 'enums/selection_mode.dart';
import 'internal/selection_group.dart';

/// A group of selection widgets.
///
/// This widget provides a standardized selection group that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSelectionGroup(
///   mode: SelectionMode.single,
///   direction: Axis.vertical,
///   children: [
///     AppRadio(...),
///     AppRadio(...),
///   ],
/// )
/// ```
class AppSelectionGroup extends StatelessWidget {
  /// The selection mode.
  final SelectionMode mode;

  /// The children widgets.
  final List<Widget> children;

  /// The direction of the group.
  final Axis direction;

  /// Creates a new [AppSelectionGroup].
  const AppSelectionGroup({
    super.key,
    required this.mode,
    required this.children,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionGroup(
      mode: mode,
      direction: direction,
      children: children,
    );
  }
}
