// lib/presentation/widgets/domain/family/member_role_badge.dart

import 'package:flutter/material.dart';

import '../../badges/app_badge.dart';
import '../../badges/enums/badge_variant.dart';
import '../../badges/enums/badge_size.dart';
import '../../badges/enums/badge_shape.dart';

/// A badge for displaying member role.
///
/// This widget provides a standardized member role badge for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// MemberRoleBadge(
///   role: 'Father',
/// )
/// ```
class MemberRoleBadge extends StatelessWidget {
  /// The role text.
  final String role;

  /// The size of the badge.
  final BadgeSize size;

  /// Creates a new [MemberRoleBadge].
  const MemberRoleBadge({
    super.key,
    required this.role,
    this.size = BadgeSize.small,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: role,
      variant: _getRoleVariant(role),
      size: size,
      shape: BadgeShape.pill,
    );
  }

  BadgeVariant _getRoleVariant(String role) {
    final lower = role.toLowerCase();
    if (lower.contains('admin') || lower.contains('owner')) {
      return BadgeVariant.primary;
    }
    if (lower.contains('parent') || lower.contains('father') || lower.contains('mother')) {
      return BadgeVariant.secondary;
    }
    if (lower.contains('child') || lower.contains('kid')) {
      return BadgeVariant.success;
    }
    return BadgeVariant.neutral;
  }
}
