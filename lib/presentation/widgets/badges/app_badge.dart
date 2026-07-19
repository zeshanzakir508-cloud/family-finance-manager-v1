// lib/presentation/widgets/badges/app_badge.dart

import 'package:flutter/material.dart';

import 'enums/badge_variant.dart';
import 'enums/badge_size.dart';
import 'enums/badge_shape.dart';
import 'helpers/badge_style_builder.dart';
import 'internal/badge_content.dart';

/// A customizable badge widget for the application.
///
/// This widget provides a standardized badge with consistent styling,
/// supporting labels, icons, and various shapes.
///
/// Example:
/// ```dart
/// AppBadge(
///   label: 'New',
///   variant: BadgeVariant.primary,
///   size: BadgeSize.medium,
///   shape: BadgeShape.pill,
/// )
/// ```
class AppBadge extends StatelessWidget {
  /// The label text to display.
  final String? label;

  /// The icon to display.
  final IconData? icon;

  /// The visual variant of the badge.
  final BadgeVariant variant;

  /// The size of the badge.
  final BadgeSize size;

  /// The shape of the badge.
  final BadgeShape shape;

  /// Whether the badge is selected.
  final bool selected;

  /// Whether the badge is disabled.
  final bool disabled;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom shape override.
  final ShapeBorder? shapeOverride;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppBadge].
  const AppBadge({
    super.key,
    this.label,
    this.icon,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.medium,
    this.shape = BadgeShape.pill,
    this.selected = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.shapeOverride,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final style = BadgeStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: shape,
    );

    final colors = style.resolve(
      selected: selected,
      disabled: disabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectivePadding = padding ?? style.padding;
    final effectiveShape = shapeOverride ?? style.shape;

    final content = BadgeContent(
      label: label,
      icon: icon,
      style: style,
      colors: colors,
      selected: selected,
    );

    return Container(
      decoration: ShapeDecoration(
        color: bgColor,
        shape: effectiveShape,
      ),
      padding: effectivePadding,
      child: Center(
        child: content,
      ),
    );
  }
}
