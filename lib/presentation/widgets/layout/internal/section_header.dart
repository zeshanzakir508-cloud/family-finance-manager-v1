// lib/presentation/widgets/layout/internal/section_header.dart

import 'package:flutter/material.dart';

import '../helpers/section_style_builder.dart';

/// Internal widget for rendering section header.
class SectionHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final SectionStyle style;

  const SectionHeader({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final hasTrailing = trailing != null;

    if (!hasTitle && !hasSubtitle && !hasTrailing) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    if (hasTitle || hasSubtitle) {
      children.add(
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasTitle)
                Text(
                  title!,
                  style: style.titleStyle,
                ),
              if (hasTitle && hasSubtitle)
                const SizedBox(height: 2),
              if (hasSubtitle)
                Text(
                  subtitle!,
                  style: style.subtitleStyle,
                ),
            ],
          ),
        ),
      );
    }

    if (hasTrailing) {
      children.add(const SizedBox(width: 8));
      children.add(trailing!);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
