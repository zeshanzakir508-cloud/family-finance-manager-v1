// lib/presentation/widgets/overlays/app_side_sheet.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_position.dart';
import 'enums/overlay_animation.dart';
import 'helpers/sheet_style_builder.dart';
import 'internal/overlay_header.dart';

/// A side sheet widget with consistent styling.
///
/// This widget provides a standardized side sheet that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSideSheet.show(
///   context,
///   title: 'Filters',
///   child: FilterWidget(),
///   position: OverlayPosition.right,
/// )
/// ```
class AppSideSheet extends StatelessWidget {
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

  /// The position of the sheet.
  final OverlayPosition position;

  /// Whether the sheet is scrollable.
  final bool isScrollable;

  /// The animation type.
  final OverlayAnimation animation;

  /// Creates a new [AppSideSheet].
  const AppSideSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = OverlayVariant.surface,
    this.position = OverlayPosition.right,
    this.isScrollable = false,
    this.animation = OverlayAnimation.slideRight,
  });

  /// Shows the side sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    OverlayVariant variant = OverlayVariant.surface,
    OverlayPosition position = OverlayPosition.right,
    bool isScrollable = false,
    OverlayAnimation animation = OverlayAnimation.slideRight,
    bool isDismissible = true,
    double width = 320,
    Color? barrierColor,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      barrierLabel: 'Side Sheet',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: position == OverlayPosition.right
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: SizedBox(
            width: width,
            height: double.infinity,
            child: AppSideSheet(
              title: title,
              subtitle: subtitle,
              leading: leading,
              trailing: trailing,
              variant: variant,
              position: position,
              isScrollable: isScrollable,
              animation: animation,
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final beginOffset = position == OverlayPosition.right
            ? const Offset(1, 0)
            : const Offset(-1, 0);
        final endOffset = Offset.zero;
        final tween = Tween<Offset>(begin: beginOffset, end: endOffset);

        return SlideTransition(
          position: animation.drive(tween),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        isScrollable
            ? Expanded(
                child: SingleChildScrollView(
                  padding: style.padding,
                  child: child,
                ),
              )
            : Expanded(
                child: Padding(
                  padding: style.padding,
                  child: child,
                ),
              ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
        left: position == OverlayPosition.left
            ? Radius.zero
            : Radius.circular(style.borderRadius),
        right: position == OverlayPosition.right
            ? Radius.zero
            : Radius.circular(style.borderRadius),
      ),
      child: Container(
        color: style.backgroundColor,
        child: content,
      ),
    );
  }
}
