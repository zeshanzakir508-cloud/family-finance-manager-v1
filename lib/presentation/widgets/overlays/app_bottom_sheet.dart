// lib/presentation/widgets/overlays/app_bottom_sheet.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_animation.dart';
import 'helpers/sheet_style_builder.dart';
import 'internal/overlay_header.dart';

/// A bottom sheet widget with consistent styling.
///
/// This widget provides a standardized bottom sheet that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppBottomSheet.show(
///   context,
///   title: 'Filter Transactions',
///   child: FilterWidget(),
/// )
/// ```
class AppBottomSheet extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The title of the sheet.
  final String? title;

  /// The subtitle of the sheet.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the sheet.
  final OverlayVariant variant;

  /// Whether the sheet is scrollable.
  final bool isScrollable;

  /// The animation type.
  final OverlayAnimation animation;

  /// Creates a new [AppBottomSheet].
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = OverlayVariant.surface,
    this.isScrollable = false,
    this.animation = OverlayAnimation.slideBottom,
  });

  /// Shows the bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    OverlayVariant variant = OverlayVariant.surface,
    bool isScrollable = false,
    OverlayAnimation animation = OverlayAnimation.slideBottom,
    bool isDismissible = true,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AppBottomSheet(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          variant: variant,
          isScrollable: isScrollable,
          animation: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = SheetStyleBuilder.build(
      context: context,
      variant: variant,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            width: style.handleWidth,
            height: style.handleHeight,
            decoration: BoxDecoration(
              color: style.foregroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(style.handleRadius),
            ),
          ),
        ),
        // Header
        OverlayHeader(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          style: OverlayStyle(
            backgroundColor: style.backgroundColor,
            foregroundColor: style.foregroundColor,
            elevation: 0,
            padding: style.padding,
            borderRadius: BorderRadius.zero,
            titleStyle: style.titleStyle,
            subtitleStyle: style.subtitleStyle,
          ),
        ),
        // Content
        isScrollable
            ? Flexible(
                child: SingleChildScrollView(
                  padding: style.padding,
                  child: child,
                ),
              )
            : Padding(
                padding: style.padding,
                child: child,
              ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(style.borderRadius)),
      child: Container(
        color: style.backgroundColor,
        child: content,
      ),
    );
  }
}
