// lib/presentation/widgets/overlays/app_tooltip.dart

import 'package:flutter/material.dart';

import 'enums/overlay_position.dart';
import 'helpers/tooltip_style_builder.dart';
import 'internal/overlay_arrow.dart';

/// A tooltip widget with consistent styling.
///
/// This widget provides a standardized tooltip that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppTooltip(
///   message: 'This is a tooltip',
///   child: Icon(Icons.info),
///   position: OverlayPosition.top,
/// )
/// ```
class AppTooltip extends StatelessWidget {
  /// The tooltip message.
  final String message;

  /// The child widget.
  final Widget child;

  /// The position of the tooltip relative to the child.
  final OverlayPosition position;

  /// The offset of the tooltip from the child.
  final Offset offset;

  /// The maximum width of the tooltip.
  final double maxWidth;

  /// Creates a new [AppTooltip].
  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = OverlayPosition.top,
    this.offset = const Offset(0, 8),
    this.maxWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: child,
      verticalOffset: position == OverlayPosition.top ? -offset.dy : offset.dy,
      preferBelow: position == OverlayPosition.bottom,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
    );
  }
}
