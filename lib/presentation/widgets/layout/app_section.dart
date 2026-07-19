// lib/presentation/widgets/layout/app_section.dart

import 'package:flutter/material.dart';

import 'enums/section_variant.dart';
import 'helpers/section_style_builder.dart';
import 'internal/section_header.dart';
import 'internal/section_footer.dart';

/// A section widget with consistent styling.
///
/// This widget provides a standardized section with header, content,
/// and footer support.
///
/// Example:
/// ```dart
/// AppSection(
///   title: 'Transactions',
///   subtitle: 'Recent activity',
///   trailing: IconButton(...),
///   child: TransactionList(),
///   footer: Text('Showing 10 items'),
/// )
/// ```
class AppSection extends StatelessWidget {
  /// The title text.
  final String? title;

  /// The subtitle text.
  final String? subtitle;

  /// The trailing widget.
  final Widget? trailing;

  /// The main content of the section.
  final Widget child;

  /// The optional footer widget.
  final Widget? footer;

  /// The visual variant of the section.
  final SectionVariant variant;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom margin override.
  final EdgeInsetsGeometry? margin;

  /// Creates a new [AppSection].
  const AppSection({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.footer,
    this.variant = SectionVariant.normal,
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final style = SectionStyleBuilder.build(
      context: context,
      variant: variant,
    );

    final bgColor = backgroundColor ?? style.backgroundColor;
    final effectivePadding = padding ?? style.padding;
    final effectiveMargin = margin ?? style.margin;

    final hasHeader = title != null || subtitle != null || trailing != null;
    final hasFooter = footer != null;

    return Container(
      margin: effectiveMargin,
      padding: style.border != null ? const EdgeInsets.all(0) : null,
      decoration: style.border != null
          ? BoxDecoration(
              color: bgColor,
              borderRadius: style.borderRadius,
              border: Border.all(
                color: style.border!.color,
                width: style.border!.width,
              ),
            )
          : null,
      child: Material(
        color: style.border != null ? Colors.transparent : bgColor,
        elevation: style.elevation,
        borderRadius: style.borderRadius,
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasHeader)
                SectionHeader(
                  title: title,
                  subtitle: subtitle,
                  trailing: trailing,
                  style: style,
                ),
              child,
              if (hasFooter)
                SectionFooter(
                  child: footer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
