import 'package:flutter/material.dart';

import 'app_card.dart';
import 'enums/card_elevation.dart';
import 'enums/card_variant.dart';

/// A specialized information card built on top of [AppCard].
///
/// This widget is intended for displaying structured information such as:
/// - User profile
/// - Bank account details
/// - Family information
/// - Subscription details
/// - Wallet information
///
/// It reuses [AppCard] and adds no business logic.
///
/// Example:
/// ```dart
/// AppInfoCard(
///   leading: const Icon(Icons.account_balance_wallet),
///   title: 'Wallet Balance',
///   subtitle: 'Primary Wallet',
///   child: Text('PKR 12,500'),
/// )
/// ```
class AppInfoCard extends StatelessWidget {
  /// Leading widget displayed before the title.
  final Widget? leading;

  /// Title of the information card.
  final String? title;

  /// Subtitle displayed below the title.
  final String? subtitle;

  /// Trailing widget displayed after the title.
  final Widget? trailing;

  /// Main content of the card.
  final Widget? child;

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

  /// Creates a new [AppInfoCard].
  const AppInfoCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
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
    return AppCard(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      child: child,
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
