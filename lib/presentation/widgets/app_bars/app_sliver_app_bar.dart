// lib/presentation/widgets/app_bars/app_sliver_app_bar.dart

import 'package:flutter/material.dart';

import 'enums/app_bar_variant.dart';
import 'enums/app_bar_size.dart';
import 'helpers/app_bar_style_builder.dart';
import 'internal/app_bar_title.dart';

/// A sliver app bar with consistent styling.
///
/// This widget provides a standardized sliver app bar that follows the
/// application's design system with support for multiple variants, sizes,
/// and states. It is designed to be used in [CustomScrollView].
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     AppSliverAppBar(
///       title: 'Family Finance',
///       subtitle: 'Overview',
///       expandedHeight: 200,
///       pinned: true,
///       actions: [
///         IconButton(icon: Icon(Icons.search), onPressed: () {}),
///       ],
///     ),
///     SliverList(...),
///   ],
/// )
/// ```
class AppSliverAppBar extends StatelessWidget {
  /// The main title text.
  final String title;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// Leading widget (e.g., back button, menu) displayed before the title.
  final Widget? leading;

  /// Action widgets displayed after the title.
  final List<Widget>? actions;

  /// Bottom widget (e.g., tab bar) displayed below the app bar.
  final PreferredSizeWidget? bottom;

  /// Flexible space widget for expanded state.
  final Widget? flexibleSpace;

  /// The expanded height of the app bar.
  final double? expandedHeight;

  /// The collapsed height of the app bar.
  final double? collapsedHeight;

  /// Whether the app bar floats above the content.
  final bool floating;

  /// Whether the app bar is pinned to the top.
  final bool pinned;

  /// Whether the app bar snaps into place.
  final bool snap;

  /// Whether the app bar stretches.
  final bool stretch;

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

  /// Creates a new [AppSliverAppBar].
  const AppSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.flexibleSpace,
    this.expandedHeight,
    this.collapsedHeight,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.variant = AppBarVariant.primary,
    this.size = AppBarSize.large,
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

    return SliverAppBar(
      title: titleWidget,
      leading: leading,
      actions: actions,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
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
