// lib/presentation/templates/app_master_detail_page.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A master-detail page template with consistent styling.
///
/// This widget provides a standardized master-detail page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppMasterDetailPage(
///   title: 'Transactions',
///   master: TransactionList(),
///   detail: TransactionDetail(),
///   splitRatio: 0.3,
/// )
/// ```
class AppMasterDetailPage extends StatelessWidget {
  /// The master (list) widget.
  final Widget master;

  /// The detail widget.
  final Widget detail;

  /// The split ratio (master width / total width).
  final double splitRatio;

  /// The minimum master width.
  final double minMasterWidth;

  /// The maximum master width.
  final double maxMasterWidth;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppMasterDetailPage].
  const AppMasterDetailPage({
    super.key,
    required this.master,
    required this.detail,
    this.splitRatio = 0.3,
    this.minMasterWidth = 200,
    this.maxMasterWidth = 400,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = PageStyleBuilder.build(
      context: context,
      variant: variant,
      density: density,
    );

    final body = LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (!isWide) {
          // On narrow screens, show master with navigation to detail
          return master;
        }

        // On wide screens, show split view
        return Row(
          children: [
            Container(
              width: constraints.maxWidth * splitRatio.clamp(
                minMasterWidth / constraints.maxWidth,
                maxMasterWidth / constraints.maxWidth,
              ),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
