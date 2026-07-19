// lib/presentation/widgets/app_bars/internal/app_bar_title.dart

import 'package:flutter/material.dart';

import '../helpers/app_bar_style_builder.dart';

/// Internal widget for rendering app bar title with optional subtitle.
///
/// This widget is shared between [AppAppBar] and [AppSliverAppBar] to ensure
/// consistent title rendering across all app bar variants.
class AppBarTitle extends StatelessWidget {
  /// The main title text.
  final String title;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// The text style for the title.
  final TextStyle titleStyle;

  /// The text style for the subtitle.
  final TextStyle subtitleStyle;

  /// The color of the title text.
  final Color titleColor;

  /// The color of the subtitle text.
  final Color subtitleColor;

  /// The padding around the title.
  final EdgeInsets padding;

  /// The spacing between the title and subtitle.
  final double spacing;

  /// Creates a new [AppBarTitle].
  const AppBarTitle({
    super.key,
    required this.title,
    this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.titleColor,
    required this.subtitleColor,
    required this.padding,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle.copyWith(color: titleColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (hasSubtitle) ...[
            SizedBox(height: spacing),
            Text(
              subtitle!,
              style: subtitleStyle.copyWith(color: subtitleColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
