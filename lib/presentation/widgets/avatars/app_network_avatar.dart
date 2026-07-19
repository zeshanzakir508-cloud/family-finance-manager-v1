// lib/presentation/widgets/avatars/app_network_avatar.dart

import 'package:flutter/material.dart';

import 'app_avatar.dart';
import 'enums/avatar_variant.dart';
import 'enums/avatar_size.dart';
import 'enums/avatar_shape.dart';

/// An avatar that displays an image from a network URL.
///
/// This widget provides a standardized network avatar with built-in
/// loading and error handling.
///
/// Example:
/// ```dart
/// AppNetworkAvatar(
///   url: 'https://example.com/profile.jpg',
///   size: AvatarSize.large,
///   placeholder: Icon(Icons.person),
/// )
/// ```
class AppNetworkAvatar extends StatelessWidget {
  /// The URL of the image to display.
  final String url;

  /// The placeholder widget to show while loading.
  final Widget? placeholder;

  /// The error widget to show on failure.
  final Widget? errorWidget;

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

  /// Creates a new [AppNetworkAvatar].
  const AppNetworkAvatar({
    super.key,
    required this.url,
    this.placeholder,
    this.errorWidget,
    this.variant = AvatarVariant.filled,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circular,
    this.selected = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppAvatar(
      image: NetworkImage(url),
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
}
