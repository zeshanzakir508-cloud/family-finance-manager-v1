// lib/presentation/widgets/badges/internal/badge_content.dart

import 'package:flutter/material.dart';

import '../helpers/badge_style_builder.dart';

/// Internal widget for rendering badge content.
///
/// This widget provides consistent rendering of badge content with
/// optional icon and label.
class BadgeContent extends StatelessWidget {
  /// The label text to display.
  final String? label;

  /// The icon to display.
  final IconData? icon;

  /// The badge style.
  final BadgeStyle style;

  /// The resolved colors for the current state.
  final BadgeColors colors;

  /// Whether the badge is selected.
  final bool selected;

  /// Creates a new [BadgeContent].
  const BadgeContent({
    super.key,
    this.label,
    this.icon,
    required this.style,
    required this.colors,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = colors.foreground;

    if (label != null && label!.isNotEmpty) {
      return Text(
        label!,
        style: style.textStyle.copyWith(
          color: fgColor,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        color: fgColor,
        size: style.iconSize,
      );
    }

    return const SizedBox.shrink();
  }
}
