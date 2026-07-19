// lib/presentation/widgets/tiles/app_account_tile.dart

import 'package:flutter/material.dart';

import 'app_tile.dart';
import 'enums/tile_variant.dart';
import 'enums/tile_size.dart';
import 'enums/tile_density.dart';
import 'helpers/tile_style_builder.dart';

/// An account tile for displaying bank/wallet accounts.
///
/// This widget provides a standardized account tile that accepts
/// pre-built widgets for all dynamic content. All formatting and business
/// logic should be done before passing data to this widget.
///
/// Example:
/// ```dart
/// AppAccountTile(
///   icon: Icon(Icons.account_balance),
///   name: 'Bank Al Habib',
///   accountNumber: '****1234',
///   balance: Text(
///     'PKR 56,200.00',
///     style: TextStyle(fontWeight: FontWeight.bold),
///   ),
///   status: Container(
///     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
///     decoration: BoxDecoration(
///       color: Colors.green.withOpacity(0.2),
///       borderRadius: BorderRadius.circular(10),
///     ),
///     child: Text('Active', style: TextStyle(color: Colors.green)),
///   ),
/// )
/// ```
class AppAccountTile extends StatelessWidget {
  /// The account icon.
  final Widget? icon;

  /// The account name.
  final String? name;

  /// The account number or type.
  final String? accountNumber;

  /// The formatted balance widget.
  final Widget? balance;

  /// The status widget.
  final Widget? status;

  /// Custom trailing widget.
  final Widget? trailing;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Callback when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is selected.
  final bool selected;

  /// Whether the tile is disabled.
  final bool isDisabled;

  /// The visual variant of the tile.
  final TileVariant variant;

  /// The size of the tile.
  final TileSize size;

  /// The density of the tile.
  final TileDensity density;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom margin override.
  final EdgeInsetsGeometry? margin;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppAccountTile].
  const AppAccountTile({
    super.key,
    this.icon,
    this.name,
    this.accountNumber,
    this.balance,
    this.status,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.isDisabled = false,
    this.variant = TileVariant.filled,
    this.size = TileSize.medium,
    this.density = TileDensity.comfortable,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.margin,
    this.shape,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final style = TileStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      density: density,
    );

    final leading = icon != null
        ? CircleAvatar(
            radius: style.avatarRadius,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: IconTheme(
              data: IconThemeData(
                color: colorScheme.primary,
                size: style.iconSize * 0.8,
              ),
              child: icon!,
            ),
          )
        : null;

    final subtitle = <String>[];
    if (accountNumber != null && accountNumber!.isNotEmpty) {
      subtitle.add(accountNumber!);
    }
    final subtitleText = subtitle.join(' • ');

    final trailingWidget = trailing ??
        (balance != null || status != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (balance != null) balance!,
                  if (status != null) status!,
                ],
              )
            : null);

    return AppTile(
      title: name,
      subtitle: subtitleText.isNotEmpty ? subtitleText : null,
      leading: leading,
      trailing: trailingWidget,
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected,
      isDisabled: isDisabled,
      variant: variant,
      size: size,
      density: density,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      shape: shape,
      border: border,
    );
  }
}
