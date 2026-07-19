// lib/presentation/widgets/avatars/app_group_avatar.dart

import 'package:flutter/material.dart';

import 'app_avatar.dart';
import 'app_initials_avatar.dart';
import 'enums/avatar_size.dart';
import 'enums/avatar_shape.dart';

/// An avatar that displays a group of avatars stacked together.
///
/// This widget provides a standardized group avatar for displaying
/// multiple avatars in a stack, commonly used for families, teams,
/// or shared accounts.
///
/// Example:
/// ```dart
/// AppGroupAvatar(
///   members: ['John Doe', 'Jane Smith', 'Bob Johnson'],
///   size: AvatarSize.medium,
///   maxDisplay: 3,
/// )
/// ```
class AppGroupAvatar extends StatelessWidget {
  /// The list of member names to display.
  final List<String> members;

  /// The size of each avatar.
  final AvatarSize size;

  /// The shape of each avatar.
  final AvatarShape shape;

  /// The maximum number of avatars to display before showing a count.
  final int maxDisplay;

  /// The overlap amount between avatars.
  final double overlap;

  /// Whether the avatars are disabled.
  final bool disabled;

  /// Creates a new [AppGroupAvatar].
  const AppGroupAvatar({
    super.key,
    required this.members,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circular,
    this.maxDisplay = 3,
    this.overlap = 0.4,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayMembers = members.take(maxDisplay).toList();
    final remainingCount = members.length - maxDisplay;
    final showRemaining = remainingCount > 0;

    final sizeValue = size.value;
    final spacing = sizeValue * (1 - overlap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < displayMembers.length; i++)
          Transform.translate(
            offset: Offset(-spacing * i, 0),
            child: AppInitialsAvatar(
              name: displayMembers[i],
              size: size,
              shape: shape,
              disabled: disabled,
            ),
          ),
        if (showRemaining)
          Transform.translate(
            offset: Offset(-spacing * displayMembers.length, 0),
            child: AppAvatar(
              initials: '+$remainingCount',
              size: size,
              shape: shape,
              disabled: disabled,
              variant: AvatarVariant.tonal,
            ),
          ),
      ],
    );
  }
}
