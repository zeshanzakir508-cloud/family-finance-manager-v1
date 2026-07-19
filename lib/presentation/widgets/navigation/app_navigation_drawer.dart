// lib/presentation/widgets/navigation/app_navigation_drawer.dart

import 'package:flutter/material.dart';

import 'enums/navigation_variant.dart';
import 'enums/navigation_size.dart';
import 'helpers/navigation_style_builder.dart';

/// A navigation drawer with consistent styling.
///
/// This widget provides a standardized navigation drawer that follows
/// the application's design system with support for multiple variants.
///
/// Example:
/// ```dart
/// AppNavigationDrawer(
///   header: DrawerHeader(
///     child: Text('My App'),
///   ),
///   items: [
///     ListTile(
///       leading: Icon(Icons.home),
///       title: Text('Home'),
///       onTap: () => Navigator.pop(context),
///     ),
///   ],
/// )
/// ```
class AppNavigationDrawer extends StatelessWidget {
  /// The header widget of the drawer.
  final Widget? header;

  /// The list of items in the drawer.
  final List<Widget> items;

  /// The visual variant of the drawer.
  final NavigationVariant variant;

  /// The size of the drawer.
  final NavigationSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Whether the drawer is disabled.
  final bool disabled;

  /// The width of the drawer.
  final double? width;

  /// Creates a new [AppNavigationDrawer].
  const AppNavigationDrawer({
    super.key,
    this.header,
    required this.items,
    this.variant = NavigationVariant.surface,
    this.size = NavigationSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.disabled = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final style = NavigationStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
    );

    final colors = style.resolve(
      selected: false,
      disabled: disabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;

    return Drawer(
      width: width ?? 320,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) header!,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}
