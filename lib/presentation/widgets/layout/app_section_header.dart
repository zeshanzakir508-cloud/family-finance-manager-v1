// lib/presentation/widgets/layout/app_section_header.dart

import 'package:flutter/material.dart';

import 'enums/section_variant.dart';
import 'helpers/section_style_builder.dart';
import 'internal/section_header.dart';

/// A standalone section header widget.
///
/// This widget provides a standardized section header that can be used
/// independently of [AppSection].
///
/// Example:
/// ```dart
/// AppSectionHeader(
///   title: 'Recent Transactions',
///   subtitle: 'Last 7 days',
///   trailing: Icon(Icons.arrow_forward),
/// )
/// ```
class AppSectionHeader extends StatelessWidget {
  /// The title text.
  final String? title;

  /// The subtitle text.
  final String? subtitle;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the header.
  final SectionVariant variant;

  /// Creates a new [AppSectionHeader].
  const AppSectionHeader({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.variant = SectionVariant.normal,
  });

  @override
  Widget build(BuildContext context) {
    final style = SectionStyleBuilder.build(
      context: context,
      variant: variant,
    );

    return SectionHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      style: style,
    );
  }
}
