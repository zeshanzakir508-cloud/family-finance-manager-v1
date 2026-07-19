// lib/presentation/widgets/cards/app_card.dart

import 'package:flutter/material.dart';

import 'enums/card_variant.dart';
import 'enums/card_elevation.dart';
import 'helpers/card_style_builder.dart';

/// A customizable base card widget for the application.
///
/// This widget provides a standardized card with consistent styling,
/// supporting headers, child content, and interaction. All other cards
/// (transaction, wallet, category, etc.) should reuse this widget.
///
/// Example:
/// ```dart
/// AppCard(
///   title: 'Total Balance',
///   subtitle: '\$12,450.00',
///   child: ChartWidget(),
///   onTap: () => navigateToDetails(),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// The main content of the card.
  final Widget? child;

  /// Leading widget (e.g., icon, avatar) displayed before the title.
  final Widget? leading;

  /// The title text displayed in the header.
  final String? title;

  /// The subtitle text displayed below the title.
  final String? subtitle;

  /// Trailing widget (e.g., icon button, badge) displayed after the title.
  final Widget? trailing;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// The visual variant of the card.
  final CardVariant variant;

  /// The elevation level of the card.
  final CardElevation elevation;

  /// Custom background color override.
  final Color? color;

  /// Custom padding override. Defaults to EdgeInsets.all(16).
  final EdgeInsetsGeometry? padding;

  /// Custom margin override.
  final EdgeInsetsGeometry? margin;

  /// Custom width override.
  final double? width;

  /// Custom height override.
  final double? height;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppCard].
  const AppCard({
    super.key,
    this.child,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.variant = CardVariant.filled,
    this.elevation = CardElevation.low,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shape,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final style = CardStyleBuilder.build(
      context: context,
      variant: variant,
      elevation: elevation,
    );

    final effectiveColor = color ?? style.backgroundColor;
    final effectiveBorder = border ?? style.border;
    final effectiveMargin = margin ?? const EdgeInsets.all(0);

    final effectiveShape = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: effectiveBorder ?? BorderSide.none,
        );

    final content = _buildContent(context, colorScheme);
    final effectivePadding = padding ?? const EdgeInsets.all(16);

    // Build card with InkWell inside Card
    Widget card = Card(
      color: effectiveColor,
      elevation: style.elevation,
      shape: effectiveShape,
      margin: effectiveMargin,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: _getBorderRadius(effectiveShape),
              child: Padding(
                padding: effectivePadding,
                child: content,
              ),
            )
          : Padding(
              padding: effectivePadding,
              child: content,
            ),
    );

    // Wrap with SizedBox if width or height is specified
    if (width != null || height != null) {
      card = SizedBox(
        width: width,
        height: height,
        child: card,
      );
    }

    return card;
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    final hasHeader = leading != null || title != null || subtitle != null || trailing != null;

    if (!hasHeader && child == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasHeader) ...[
          _buildHeader(context, colorScheme),
          if (child != null) const SizedBox(height: 12),
        ],
        if (child != null) child!,
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    final children = <Widget>[];

    // Leading
    if (leading != null) {
      children.add(leading!);
      children.add(const SizedBox(width: 12));
    }

    // Title and Subtitle
    final titleSubtitle = _buildTitleSubtitle(context, colorScheme);
    if (titleSubtitle != null) {
      children.add(Expanded(child: titleSubtitle));
    }

    // Trailing
    if (trailing != null) {
      children.add(const SizedBox(width: 8));
      children.add(trailing!);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget? _buildTitleSubtitle(BuildContext context, ColorScheme colorScheme) {
    final hasTitle = title != null && title!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    if (!hasTitle && !hasSubtitle) return null;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        );

    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
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
        const SizedBox(height: 2),
        Text(subtitle!, style: subtitleStyle),
      ],
    );
  }

  BorderRadiusGeometry? _getBorderRadius(ShapeBorder? shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius;
    }
    return null;
  }
}
