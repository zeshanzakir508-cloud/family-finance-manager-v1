// lib/presentation/widgets/navigation/page_header.dart

import 'package:flutter/material.dart';

import '../app_bars/app_app_bar.dart';
import '../app_bars/enums/app_bar_variant.dart';
import '../app_bars/enums/app_bar_size.dart';

/// A page header widget that combines an app bar with additional
/// header content like title, subtitle, and actions.
///
/// This widget provides a consistent page header that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// PageHeader(
///   title: 'Transactions',
///   subtitle: 'View all your transactions',
///   actions: [
///     IconButton(icon: Icon(Icons.filter), onPressed: () {}),
///   ],
///   bottom: TabBar(...),
/// )
/// ```
class PageHeader extends StatelessWidget {
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

  /// Whether the title is centered.
  final bool? centerTitle;

  /// Whether to automatically imply a leading widget.
  final bool automaticallyImplyLeading;

  /// The visual variant of the header.
  final AppBarVariant variant;

  /// The size of the header.
  final AppBarSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom elevation override.
  final double? elevation;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Creates a new [PageHeader].
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.variant = AppBarVariant.primary,
    this.size = AppBarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAppBar(
          title: title,
          subtitle: subtitle,
          leading: leading,
          actions: actions,
          centerTitle: centerTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          variant: variant,
          size: size,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shape: shape,
        ),
        if (bottom != null) bottom!,
      ],
    );
  }
}
