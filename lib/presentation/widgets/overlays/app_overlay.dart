// lib/presentation/widgets/overlays/app_overlay.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_animation.dart';
import 'enums/overlay_barrier.dart';
import 'helpers/overlay_style_builder.dart';
import 'internal/overlay_container.dart';
import 'internal/overlay_header.dart';

/// A generic overlay widget with consistent styling.
///
/// This widget provides a standardized overlay that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppOverlay(
///   title: 'Loading',
///   subtitle: 'Please wait...',
///   child: AppLoadingIndicator(),
/// )
/// ```
class AppOverlay extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The title of the overlay.
  final String? title;

  /// The subtitle of the overlay.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the overlay.
  final OverlayVariant variant;

  /// The animation type.
  final OverlayAnimation animation;

  /// The barrier behavior.
  final OverlayBarrier barrier;

  /// Creates a new [AppOverlay].
  const AppOverlay({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = OverlayVariant.surface,
    this.animation = OverlayAnimation.fade,
    this.barrier = OverlayBarrier.none,
  });

  /// Shows the overlay.
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    OverlayVariant variant = OverlayVariant.surface,
    OverlayAnimation animation = OverlayAnimation.fade,
    OverlayBarrier barrier = OverlayBarrier.dim,
    bool isDismissible = true,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isDismissible ? () => entry.remove() : null,
        child: Container(
          color: _getBarrierColor(barrier),
          child: Center(
            child: AppOverlay(
              title: title,
              subtitle: subtitle,
              leading: leading,
              trailing: trailing,
              variant: variant,
              animation: animation,
              barrier: barrier,
              child: child,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    return Future.value();
  }

  /// Dismisses the current overlay.
  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Color _getBarrierColor(OverlayBarrier barrier) {
    switch (barrier) {
      case OverlayBarrier.transparent:
        return Colors.transparent;
      case OverlayBarrier.dim:
        return Colors.black.withOpacity(0.5);
      case OverlayBarrier.opaque:
        return Colors.black;
      case OverlayBarrier.none:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = OverlayStyleBuilder.build(
      context: context,
      variant: variant,
    );

    return OverlayContainer(
      style: style,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OverlayHeader(
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            style: style,
          ),
          child,
        ],
      ),
    );
  }
}
