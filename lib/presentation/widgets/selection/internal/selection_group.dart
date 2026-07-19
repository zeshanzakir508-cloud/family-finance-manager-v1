// lib/presentation/widgets/selection/internal/selection_group.dart

import 'package:flutter/material.dart';

import '../enums/selection_mode.dart';

/// Internal widget for rendering a selection group.
class SelectionGroup extends StatelessWidget {
  final SelectionMode mode;
  final List<Widget> children;
  final Axis direction;

  const SelectionGroup({
    super.key,
    required this.mode,
    required this.children,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: 8,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index == children.length - 1 ? 0 : 8),
          child: child,
        );
      }).toList(),
    );
  }
}
