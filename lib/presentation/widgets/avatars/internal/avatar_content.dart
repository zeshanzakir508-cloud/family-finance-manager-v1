// lib/presentation/widgets/avatars/internal/avatar_content.dart

import 'package:flutter/material.dart';

import '../helpers/avatar_style_builder.dart';

/// Internal widget for rendering avatar content.
///
/// This widget provides consistent rendering of avatar content with
/// optional image, initials, and icon.
class AvatarContent extends StatelessWidget {
  /// The image provider for the avatar.
  final ImageProvider? image;

  /// The initials text to display.
  final String? initials;

  /// The icon to display.
  final IconData? icon;

  /// The avatar style.
  final AvatarStyle style;

  /// The resolved colors for the current state.
  final AvatarColors colors;

  /// Whether the avatar is selected.
  final bool selected;

  /// Creates a new [AvatarContent].
  const AvatarContent({
    super.key,
    this.image,
    this.initials,
    this.icon,
    required this.style,
    required this.colors,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = colors.foreground;

    // Image
    if (image != null) {
      return Image(
        image: image!,
        fit: BoxFit.cover,
        width: style.size,
        height: style.size,
      );
    }

    // Initials
    if (initials != null && initials!.isNotEmpty) {
      return Text(
        initials!,
        style: style.textStyle.copyWith(
          color: fgColor,
          fontSize: style.fontSize,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Icon
    if (icon != null) {
      return Icon(
        icon,
        color: fgColor,
        size: style.iconSize,
      );
    }

    // Default: fallback icon
    return Icon(
      Icons.person,
      color: fgColor,
      size: style.iconSize,
    );
  }
}
