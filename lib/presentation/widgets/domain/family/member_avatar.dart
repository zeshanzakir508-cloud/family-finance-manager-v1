// lib/presentation/widgets/domain/family/member_avatar.dart

import 'package:flutter/material.dart';

import '../../avatars/app_avatar.dart';
import '../../avatars/enums/avatar_variant.dart';
import '../../avatars/enums/avatar_size.dart';
import '../../avatars/enums/avatar_shape.dart';

/// An avatar for a family member.
///
/// This widget provides a standardized family member avatar for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// MemberAvatar(
///   name: 'John Doe',
///   imageUrl: 'https://example.com/photo.jpg',
///   size: AvatarSize.medium,
/// )
/// ```
class MemberAvatar extends StatelessWidget {
  /// The member name (for initials).
  final String? name;

  /// The image URL.
  final String? imageUrl;

  /// The avatar size.
  final AvatarSize size;

  /// The avatar shape.
  final AvatarShape shape;

  /// Whether the member is active.
  final bool isActive;

  /// Creates a new [MemberAvatar].
  const MemberAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circular,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name != null && name!.isNotEmpty
        ? name!.split(' ').take(2).map((n) => n[0]).join()
        : '?';

    return Stack(
      children: [
        imageUrl != null
            ? AppNetworkImage(
                url: imageUrl!,
                fit: ImageFit.cover,
                shape: shape == AvatarShape.circular
                    ? ImageShape.circular
                    : ImageShape.rounded,
                width: size.value,
                height: size.value,
              )
            : AppAvatar(
                initials: initials,
                size: size,
                shape: shape,
                variant: AvatarVariant.filled,
              ),
        if (!isActive)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: shape == AvatarShape.circular
                    ? BoxShape.circle
                    : BoxShape.rectangle,
              ),
            ),
          ),
      ],
    );
  }
}
