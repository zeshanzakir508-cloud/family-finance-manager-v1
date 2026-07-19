// lib/presentation/widgets/overlays/app_popover.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_position.dart';
import 'enums/overlay_animation.dart';
import 'enums/overlay_barrier.dart';
import 'helpers/overlay_style_builder.dart';
import 'internal/overlay_container.dart';
import 'internal/overlay_arrow.dart';

/// A popover widget with consistent styling.
///
/// This widget provides a standardized popover that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppPopover(
///   content: Text('This is a popover'),
///   child: IconButton(icon: Icon(Icons.info)),
///   position: OverlayPosition.bottom,
/// )
/// ```
class AppPopover extends StatelessWidget {
  /// The content of the popover.
  final Widget content;

  /// The child widget that triggers the popover.
  final Widget child;

  /// The visual variant of the popover.
  final OverlayVariant variant;

  /// The position of the popover relative to the child.
  final OverlayPosition position;

  /// The animation type.
  final OverlayAnimation animation;

  /// The offset of the popover from the child.
  final Offset offset;

  /// The barrier behavior.
  final OverlayBarrier barrier;

  /// The maximum width of the popover.
  final double maxWidth;

  /// Creates a new [AppPopover].
  const AppPopover({
    super.key,
    required this.content,
    required this.child,
    this.variant = OverlayVariant.surface,
    this.position = OverlayPosition.bottom,
    this.animation = OverlayAnimation.scale,
    this.offset = const Offset(0, 8),
    this.barrier = OverlayBarrier.none,
    this.maxWidth = 280,
  });

  @override
  Widget build(BuildContext context) {
    final style = OverlayStyleBuilder.build(
      context: context,
      variant: variant,
    );

    return GestureDetector(
      onTap: () => _showPopover(context, style),
      child: child,
    );
  }

  void _showPopover(BuildContext context, OverlayStyle style) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    final entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _dismiss(entry),
        child: Container(
          color: _getBarrierColor(),
          child: Stack(
            children: [
              Positioned(
                left: position.dx + offset.dx,
                top: position.dy + renderBox.size.height + offset.dy,
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: OverlayContainer(
                      style: style,
                      child: content,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }

  void _dismiss(OverlayEntry entry) {
    entry.remove();
  }

  Color _getBarrierColor() {
    switch (barrier) {
      case OverlayBarrier.transparent:
        return Colors.transparent;
      case OverlayBarrier.dim:
        return Colors.black.withOpacity(0.3);
      case OverlayBarrier.opaque:
        return Colors.black;
      case OverlayBarrier.none:
        return Colors.transparent;
    }
  }
}
