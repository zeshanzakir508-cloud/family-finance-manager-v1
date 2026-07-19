import 'package:flutter/material.dart';

import 'app_card.dart';
import 'enums/card_elevation.dart';
import 'enums/card_variant.dart';

/// A specialized action card built on top of [AppCard].
///
/// This widget is intended for displaying tappable actions such as:
/// - Transfer Money
/// - Manage Categories
/// - Reports
/// - Settings
/// - Export Data
/// - Family Management
///
/// It reuses [AppCard] and adds no business logic.
///
/// Example:
/// ```dart
/// AppActionCard(
///   leading: const Icon(Icons.send),
///   title: 'Transfer Money',
///   subtitle: 'Move funds between accounts',
///   onTap: () {},
/// )
/// ```
class AppActionCard extends StatelessWidget {
  /// Leading widget displayed before the title.
  final Widget? leading;

  /// Action title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Trailing widget.
  ///
  /// Defaults to a chevron icon when not provided.
  final Widget? trailing;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Card visual variant.
  final CardVariant variant;

  /// Card elevation.
  final CardElevation elevation;

  /// Background color override.
  final Color? color;

  /// Content padding override.
  final EdgeInsetsGeometry? padding;

  /// Margin override.
  final EdgeInsetsGeometry? margin;

  /// Width override.
  final double? width;

  /// Height override.
  final double? height;

  /// Shape override.
  final ShapeBorder? shape;

  /// Border override.
  final BorderSide? border;

  /// Creates a new [AppActionCard].
  const AppActionCard({
    super.key,
    required this.title,
    this.leading,
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

    return AppCard(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
      onTap: onTap,
      variant: variant,
      elevation: elevation,
      color: color,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      shape: shape,
      border: border,
    );
  }
}
