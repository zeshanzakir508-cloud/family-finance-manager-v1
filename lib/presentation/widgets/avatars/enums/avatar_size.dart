// lib/presentation/widgets/avatars/enums/avatar_size.dart

/// The size of the avatar.
enum AvatarSize {
  /// Extra small avatar (24px).
  extraSmall,

  /// Small avatar (32px).
  small,

  /// Medium avatar (40px).
  medium,

  /// Large avatar (48px).
  large,

  /// Extra large avatar (56px).
  extraLarge,

  /// Huge avatar (72px).
  huge;

  /// Returns the size in pixels for this avatar size.
  double get value {
    switch (this) {
      case AvatarSize.extraSmall:
        return 24;
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 40;
      case AvatarSize.large:
        return 48;
      case AvatarSize.extraLarge:
        return 56;
      case AvatarSize.huge:
        return 72;
    }
  }
}
