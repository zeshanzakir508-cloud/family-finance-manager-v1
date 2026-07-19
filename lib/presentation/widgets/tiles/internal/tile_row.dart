// lib/presentation/widgets/tiles/internal/tile_row.dart

import 'package:flutter/material.dart';

import '../helpers/tile_style_builder.dart';
import 'tile_title_subtitle.dart';

/// Internal widget for the tile row (leading | title/subtitle | trailing).
class TileRow extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final TileStyle style;
  final Color fgColor;

  const TileRow({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.style,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    final rowChildren = <Widget>[];

    // Leading
    if (leading != null) {
      rowChildren.add(
        IconTheme(
          data: IconThemeData(
            color: fgColor,
            size: style.iconSize,
          ),
          child: leading!,
        ),
      );
      rowChildren.add(SizedBox(width: style.contentSpacing));
    }

    // Title and Subtitle
    if (title != null || subtitle != null) {
      rowChildren.add(
        Expanded(
          child: TileTitleSubtitle(
            title: title,
            subtitle: subtitle,
            style: style,
            fgColor: fgColor,
          ),
        ),
      );
    }

    // Trailing
    if (trailing != null) {
      rowChildren.add(SizedBox(width: style.contentSpacing));
      rowChildren.add(
        IconTheme(
          data: IconThemeData(
            color: fgColor,
            size: style.iconSize,
          ),
          child: trailing!,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );
  }
}
