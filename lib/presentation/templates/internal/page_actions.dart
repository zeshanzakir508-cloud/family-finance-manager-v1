// lib/presentation/templates/internal/page_actions.dart

import 'package:flutter/material.dart';

/// Internal widget for page actions.
class PageActions extends StatelessWidget {
  final List<Widget> actions;
  final double spacing;
  final Axis direction;

  const PageActions({
    super.key,
    required this.actions,
    required this.spacing,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions
            .expand((action) => [
                  action,
                  if (actions.indexOf(action) < actions.length - 1)
                    SizedBox(width: spacing),
                ])
            .toList(),
      );
    }

    return Column(
      children: actions
          .expand((action) => [
                action,
                if (actions.indexOf(action) < actions.length - 1)
                  SizedBox(height: spacing),
              ])
          .toList(),
    );
  }
}
