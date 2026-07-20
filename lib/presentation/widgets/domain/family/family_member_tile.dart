// lib/presentation/widgets/domain/family/family_member_tile.dart

import 'package:flutter/material.dart';

import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';
import '../../tiles/enums/tile_size.dart';
import '../../tiles/enums/tile_density.dart';
import '../../badges/app_badge.dart';
import '../../badges/enums/badge_variant.dart';
import '../../badges/enums/badge_size.dart';
import '../../badges/enums/badge_shape.dart';

/// A tile for displaying family member information.
///
/// This widget provides a standardized family member tile for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// FamilyMemberTile(
///   name: 'John Doe',
///   role: 'Father',
///   isActive: true,
///   avatar: NetworkImage('url'),
/// )
/// ```
class FamilyMemberTile extends StatelessWidget {
  /// The member name.
  final String name;

  /// The member role.
  final String? role;

  /// Whether the member is active.
  final bool isActive;

  /// The avatar widget.
  final Widget? avatar;

  /// The member email.
  final String? email;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Creates a new [FamilyMemberTile].
  const FamilyMemberTile({
    super.key,
    required this.name,
    this.role,
    this.isActive = true,
    this.avatar,
    this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final leading = avatar ??
        CircleAvatar(
          backgroundColor: colorScheme.surfaceVariant,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );

    final trailing = AppBadge(
      label: isActive ? 'Active' : 'Inactive',
      variant: isActive ? BadgeVariant.success : BadgeVariant.neutral,
      size: BadgeSize.small,
      shape: BadgeShape.pill,
    );

    final subtitle = <String>[];
    if (role != null && role!.isNotEmpty) subtitle.add(role!);
    if (email != null && email!.isNotEmpty) subtitle.add(email!);
    final subtitleText = subtitle.join(' • ');

    return AppTile(
      title: name,
      subtitle: subtitleText.isNotEmpty ? subtitleText : null,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      variant: TileVariant.filled,
      size: TileSize.medium,
      density: TileDensity.comfortable,
    );
  }
}
