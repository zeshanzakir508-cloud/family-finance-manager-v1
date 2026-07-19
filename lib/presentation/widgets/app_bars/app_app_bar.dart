import 'package:flutter/material.dart';

import 'enums/app_bar_size.dart';
import 'enums/app_bar_variant.dart';
import 'helpers/app_bar_style_builder.dart';

/// A reusable Material 3 application app bar.
///
/// [AppAppBar] wraps Flutter's [AppBar] while providing a consistent,
/// centralized styling system through [AppBarStyleBuilder].
///
/// It supports:
/// * Material 3 variants
/// * Multiple sizes
/// * Title & subtitle
/// * Leading widget
/// * Actions
/// * Bottom widgets
/// * Flexible space
/// * Disabled and selected states
///
/// Example:
///
/// ```dart
/// Scaffold(
///   appBar: const AppAppBar(
///     title: 'Dashboard',
///   ),
/// )
/// ```
class AppAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates an application app bar.
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.flexibleSpace,
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
    this.toolbarHeight,
  });

  /// Primary title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Action widgets.
  final List<Widget>? actions;

  /// Bottom widget.
  final PreferredSizeWidget? bottom;

  /// Flexible space.
  final Widget? flexibleSpace;

  /// Centers the title.
  final bool? centerTitle;

  /// Whether Flutter should automatically provide a back button.
  final bool automaticallyImplyLeading;

  /// Visual variant.
  final AppBarVariant variant;

  /// App bar size.
  final AppBarSize size;

  /// Selected state.
  final bool selected;

  /// Disabled state.
  final bool disabled;

  /// Override background color.
  final Color? backgroundColor;

  /// Override foreground color.
  final Color? foregroundColor;

  /// Override elevation.
  final double? elevation;

  /// Override shape.
  final ShapeBorder? shape;

  /// Override toolbar height.
  final double? toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(
        (toolbarHeight ?? size.toolbarHeight) +
            (bottom?.preferredSize.height ?? 0),
      );

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

    // Build implementation continues in Part 2.
    throw UnimplementedError();
  }
}
return AppBar(
  title: subtitle == null
      ? Text(
          title,
          style: style.titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: style.titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle!,
              style: style.subtitleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

  leading: leading,

  actions: actions
      ?.map(
        (action) => Padding(
          padding: EdgeInsets.only(
            right: style.actionsSpacing,
          ),
          child: IconTheme(
            data: IconThemeData(
              size: style.iconSize,
              color: foregroundColor ?? colors.foreground,
            ),
            child: action,
          ),
        ),
      )
      .toList(),

  bottom: bottom,

  flexibleSpace: flexibleSpace,

  centerTitle: centerTitle,

  automaticallyImplyLeading: automaticallyImplyLeading,

  toolbarHeight: toolbarHeight ?? style.toolbarHeight,

  leadingWidth: style.leadingWidth,

  titleSpacing: style.titleSpacing,

  backgroundColor: backgroundColor ?? colors.background,

  foregroundColor: foregroundColor ?? colors.foreground,

  elevation: elevation ?? style.elevation,

  shape: shape ?? style.shape,

  iconTheme: IconThemeData(
    size: style.iconSize,
    color: foregroundColor ?? colors.foreground,
  ),

  actionsIconTheme: IconThemeData(
    size: style.iconSize,
    color: foregroundColor ?? colors.foreground,
  ),

  titleTextStyle: style.titleStyle,

  toolbarTextStyle: style.subtitleStyle,

  scrolledUnderElevation: elevation ?? style.elevation,
);
