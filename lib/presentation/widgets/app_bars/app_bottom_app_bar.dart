// lib/presentation/widgets/app_bars/app_bottom_app_bar.dart

import 'package:flutter/material.dart';

import 'enums/app_bar_variant.dart';
import 'enums/app_bar_size.dart';
import 'helpers/app_bar_style_builder.dart';

/// A bottom app bar with consistent styling.
///
/// This widget provides a standardized bottom app bar that follows the
/// application's design system with support for multiple variants and sizes.
///
/// Example:
/// ```dart
/// AppBottomAppBar(
///   child: Row(
///     mainAxisAlignment: MainAxisAlignment.spaceAround,
///     children: [
///       IconButton(icon: Icon(Icons.home), onPressed: () {}),
///       IconButton(icon: Icon(Icons.add), onPressed: () {}),
///       IconButton(icon: Icon(Icons.person), onPressed: () {}),
///     ],
///   ),
/// )
/// ```
class AppBottomAppBar extends StatelessWidget {
  /// The child widget displayed in the bottom app bar.
  final Widget child;

  /// Whether the bottom app bar has a notch for a FAB.
  final bool notchMargin;

  /// The visual variant of the bottom app bar.
  final AppBarVariant variant;

  /// The size of the bottom app bar.
  final AppBarSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom elevation override.
  final double? elevation;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Creates a new [AppBottomAppBar].
  const AppBottomAppBar({
    super.key,
    required this.child,
    this.notchMargin = true,
    this.variant = AppBarVariant.surface,
    this.size = AppBarSize.medium,
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
      selected: false,
      disabled: false,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectiveElevation = elevation ?? style.elevation;
    final effectiveShape = shape ?? style.shape;

    return BottomAppBar(
      color: bgColor,
      elevation: effectiveElevation,
      shape: notchMargin
          ? const CircularNotchedRectangle()
          : effectiveShape as ShapeBorder?,
      child: IconTheme(
        data: IconThemeData(
          color: fgColor,
          size: style.iconSize,
        ),
        child: child,
      ),
    );
  }
}
