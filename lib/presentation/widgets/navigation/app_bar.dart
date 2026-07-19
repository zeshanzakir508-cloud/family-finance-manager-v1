// lib/presentation/widgets/navigation/app_bar.dart

import 'package:flutter/material.dart';

import '../app_bars/app_app_bar.dart';
import '../app_bars/enums/app_bar_variant.dart';
import '../app_bars/enums/app_bar_size.dart';

/// A convenience alias for [AppAppBar] to maintain consistency with the navigation module.
///
/// This widget delegates to [AppAppBar] and provides the same API,
/// ensuring consistent app bar styling across the application.
///
/// Example:
/// ```dart
/// AppBar(
///   title: 'Dashboard',
///   variant: AppBarVariant.primary,
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///   ],
/// )
/// ```
class AppBar extends StatelessWidget {
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

  /// Creates a new [AppBar].
  const AppBar({
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
    return AppAppBar(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      variant: variant,
      size: size,
      selected: selected,
      disabled: disabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shape: shape,
    );
  }
}
