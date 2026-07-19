// lib/presentation/widgets/tiles/internal/tile_title_subtitle.dart

import 'package:flutter/material.dart';

import '../helpers/tile_style_builder.dart';

/// Internal widget for the tile title and subtitle.
class TileTitleSubtitle extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final TileStyle style;
  final Color fgColor;

  const TileTitleSubtitle({
    super.key,
    this.title,
    this.subtitle,
    required this.style,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    if (!hasTitle && !hasSubtitle) {
      return const SizedBox.shrink();
    }

    final titleStyle = style.titleStyle.copyWith(color: fgColor);
    final subtitleStyle = style.subtitleStyle.copyWith(
      color: fgColor.withOpacity(0.7),
    );

    if (hasTitle && !hasSubtitle) {
      return Text(title!, style: titleStyle);
    }

    if (!hasTitle && hasSubtitle) {
      return Text(subtitle!, style: subtitleStyle);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!, style: titleStyle),
        SizedBox(height: style.contentSpacing * 0.3),
        Text(subtitle!, style: subtitleStyle),
      ],
    );
  }
}
