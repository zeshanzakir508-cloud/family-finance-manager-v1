// lib/presentation/widgets/app_bars/app_app_bar.dart

import 'package:flutter/material.dart';

import 'enums/app_bar_variant.dart';
import 'enums/app_bar_size.dart';
import 'helpers/app_bar_style_builder.dart';
import 'internal/app_bar_title.dart';

/// A customizable app bar with consistent styling.
///
/// This widget provides a standardized app bar that follows the
/// application's design system with support for multiple variants, sizes,
/// and states.
///
/// Example:
/// ```dart
/// AppAppBar(
///   title: 'Family Finance',
///   subtitle: 'Dashboard',
///   variant: AppBarVariant.primary,
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///   ],
/// )
/// ```
class AppAppBar extends StatelessWidget {
  /// The main title text.
  final String title;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// Leading widget (e.g., back button, menu) displayed before the title.
  final Widget? leading;

  /// Action widgets displayed after the title.
  final List<Widget>? actions;

  /// Whether the title is centered.
  final bool? centerTitle;

  /// Whether to automatically imply a leading widget.
  final bool automaticallyImplyLeading;

  /// The visual variant of the app bar.
  final AppBarVariant variant;

  /// The size of the app bar.
  final AppBarSize size;

  /// Whether the app bar is selected.
  final bool selected;

  /// Whether the app bar is disabled.
  final bool disabled;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom elevation override.
  final double? elevation;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Creates a new [AppAppBar].
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.variant = AppBarVariant.primary,
    this.size = AppBarSize.medium,
    this.selected = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppBarStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
    );

    final colors = style.resolve(
      selected: selected,
      disabled: disabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectiveElevation = elevation ?? style.elevation;
    final effectiveShape = shape ?? style.shape;

    final effectiveCenterTitle = centerTitle ?? (size != AppBarSize.large);

    final titleWidget = AppBarTitle(
      title: title,
      subtitle: subtitle,
      titleStyle: style.titleStyle,
      subtitleStyle: style.subtitleStyle,
      titleColor: fgColor,
      subtitleColor: fgColor.withOpacity(0.7),
      padding: style.titlePadding,
      spacing: 2,
    );

    return AppBar(
      title: titleWidget,
      leading: leading,
      actions: actions,
      centerTitle: effectiveCenterTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: effectiveElevation,
      shape: effectiveShape,
      toolbarHeight: style.toolbarHeight,
      leadingWidth: style.leadingWidth,
      titleSpacing: style.titleSpacing,
      iconTheme: IconThemeData(
        color: fgColor,
        size: style.iconSize,
      ),
      actionsIconTheme: IconThemeData(
        color: fgColor,
        size: style.iconSize,
      ),
    );
  }
}
