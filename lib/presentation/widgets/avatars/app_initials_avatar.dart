// lib/presentation/widgets/avatars/app_initials_avatar.dart

import 'package:flutter/material.dart';

import 'app_avatar.dart';
import 'enums/avatar_variant.dart';
import 'enums/avatar_size.dart';
import 'enums/avatar_shape.dart';

/// An avatar that displays initials generated from a name.
///
/// This widget automatically generates initials from a provided name
/// and displays them in a styled avatar.
///
/// Example:
/// ```dart
/// AppInitialsAvatar(
///   name: 'John Doe',
///   size: AvatarSize.medium,
///   variant: AvatarVariant.filled,
/// )
/// ```
class AppInitialsAvatar extends StatelessWidget {
  /// The name to generate initials from.
  final String name;

  /// The visual variant of the avatar.
  final AvatarVariant variant;

  /// The size of the avatar.
  final AvatarSize size;

  /// The shape of the avatar.
  final AvatarShape shape;

  /// Whether the avatar is selected.
  final bool selected;

  /// Whether the avatar is disabled.
  final bool disabled;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Callback when the avatar is tapped.
  final VoidCallback? onTap;

  /// The maximum number of initials to display.
  final int maxInitials;

  /// Creates a new [AppInitialsAvatar].
  const AppInitialsAvatar({
    super.key,
    required this.name,
    this.variant = AvatarVariant.filled,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circular,
    this.selected = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.maxInitials = 2,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name, maxInitials);

    return AppAvatar(
      initials: initials,
      variant: variant,
      size: size,
      shape: shape,
      selected: selected,
      disabled: disabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onTap: onTap,
    );
  }

  String _getInitials(String name, int maxInitials) {
    if (name.isEmpty) return '';

    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = <String>[];

    for (var i = 0; i < parts.length && i < maxInitials; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        initials.add(part[0].toUpperCase());
      }
    }

    return initials.join();
  }
}
