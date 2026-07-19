// lib/presentation/widgets/tiles/app_transaction_tile.dart

import 'package:flutter/material.dart';

import 'app_tile.dart';
import 'enums/tile_variant.dart';
import 'enums/tile_size.dart';
import 'enums/tile_density.dart';
import 'helpers/tile_style_builder.dart';

/// A transaction tile for displaying financial records.
///
/// This widget provides a standardized transaction tile that accepts
/// pre-built widgets for all dynamic content. All formatting and business
/// logic should be done before passing data to this widget.
///
/// Example:
/// ```dart
/// AppTransactionTile(
///   categoryIcon: Icon(Icons.restaurant),
///   categoryName: 'Food',
///   description: 'Lunch at Cafe',
///   amount: Text(
///     '-PKR 650.00',
///     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
///   ),
///   status: Container(
///     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
///     decoration: BoxDecoration(
///       color: Colors.green.withOpacity(0.2),
///       borderRadius: BorderRadius.circular(10),
///     ),
///     child: Text('Completed', style: TextStyle(color: Colors.green)),
///   ),
///   date: 'Yesterday',
/// )
/// ```
class AppTransactionTile extends StatelessWidget {
  /// The category icon.
  final Widget? categoryIcon;

  /// The category name.
  final String? categoryName;

  /// The transaction description or note.
  final String? description;

  /// The formatted amount widget.
  final Widget? amount;

  /// The status widget.
  final Widget? status;

  /// The transaction date.
  final String? date;

  /// Custom trailing widget override.
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

  /// Creates a new [AppTransactionTile].
  const AppTransactionTile({
    super.key,
    this.categoryIcon,
    this.categoryName,
    this.description,
    this.amount,
    this.status,
    this.date,
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

    final leading = categoryIcon != null
        ? CircleAvatar(
            radius: style.avatarRadius,
            backgroundColor: colorScheme.surfaceVariant,
            child: IconTheme(
              data: IconThemeData(
                color: colorScheme.primary,
                size: style.iconSize * 0.8,
              ),
              child: categoryIcon!,
            ),
          )
        : null;

    final subtitle = <String>[];
    if (description != null && description!.isNotEmpty) {
      subtitle.add(description!);
    }
    if (date != null && date!.isNotEmpty) {
      subtitle.add(date!);
    }
    final subtitleText = subtitle.join(' • ');

    final trailingWidget = trailing ??
        (amount != null || status != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (amount != null) amount!,
                  if (status != null) status!,
                ],
              )
            : null);

    return AppTile(
      title: categoryName,
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
