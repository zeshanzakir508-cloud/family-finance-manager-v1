// lib/presentation/widgets/overlays/app_modal.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_animation.dart';
import 'enums/overlay_barrier.dart';
import 'helpers/overlay_style_builder.dart';
import 'internal/overlay_container.dart';
import 'internal/overlay_header.dart';

/// A modal widget with consistent styling.
///
/// This widget provides a standardized modal that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppModal.show(
///   context,
///   title: 'Confirm Action',
///   child: Text('Are you sure?'),
///   actions: [
///     TextButton(onPressed: () {}, child: Text('Cancel')),
///     TextButton(onPressed: () {}, child: Text('Confirm')),
///   ],
/// )
/// ```
class AppModal extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The title of the modal.
  final String? title;

  /// The subtitle of the modal.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The actions to display at the bottom.
  final List<Widget>? actions;

  /// The visual variant of the modal.
  final OverlayVariant variant;

  /// The animation type.
  final OverlayAnimation animation;

  /// The barrier behavior.
  final OverlayBarrier barrier;

  /// The maximum width of the modal.
  final double maxWidth;

  /// Creates a new [AppModal].
  const AppModal({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.variant = OverlayVariant.surface,
    this.animation = OverlayAnimation.scale,
    this.barrier = OverlayBarrier.dim,
    this.maxWidth = 400,
  });

  /// Shows the modal.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    List<Widget>? actions,
    OverlayVariant variant = OverlayVariant.surface,
    OverlayAnimation animation = OverlayAnimation.scale,
    OverlayBarrier barrier = OverlayBarrier.dim,
    double maxWidth = 400,
    bool isDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: _getBarrierColor(barrier),
      barrierLabel: 'Modal',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AppModal(
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            actions: actions,
            variant: variant,
            animation: animation,
            barrier: barrier,
            maxWidth: maxWidth,
            child: child,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
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

    final children = <Widget>[
      OverlayHeader(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        style: style,
      ),
      child,
    ];

    if (actions != null && actions!.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!,
          ),
        ),
      );
    }

    return Center(
      child: OverlayContainer(
        style: style,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
