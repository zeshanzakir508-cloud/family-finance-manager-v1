// lib/presentation/widgets/avatars/app_avatar.dart

import 'package:flutter/material.dart';

import 'enums/avatar_variant.dart';
import 'enums/avatar_size.dart';
import 'enums/avatar_shape.dart';
import 'helpers/avatar_style_builder.dart';
import 'internal/avatar_content.dart';

/// A customizable avatar widget for the application.
///
/// This widget provides a standardized avatar with consistent styling,
/// supporting images, initials, and icons.
///
/// Example:
/// ```dart
/// AppAvatar(
///   image: NetworkImage('https://example.com/photo.jpg'),
///   size: AvatarSize.medium,
///   shape: AvatarShape.circular,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  /// The image provider for the avatar.
  final ImageProvider? image;

  /// The initials text to display.
  final String? initials;

  /// The icon to display.
  final IconData? icon;

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

  /// Custom shape override.
  final ShapeBorder? shapeOverride;

  /// Custom border override.
  final BorderSide? border;

  /// Callback when the avatar is tapped.
  final VoidCallback? onTap;

  /// Creates a new [AppAvatar].
  const AppAvatar({
    super.key,
    this.image,
    this.initials,
    this.icon,
    this.variant = AvatarVariant.filled,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circular,
    this.selected = false,
    this.disabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.shapeOverride,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = AvatarStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: shape,
    );

    final colors = style.resolve(
      selected: selected,
      disabled: disabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectiveShape = shapeOverride ?? style.shape;

    final content = AvatarContent(
      image: image,
      initials: initials,
      icon: icon,
      style: style,
      colors: colors,
      selected: selected,
    );

    final avatar = Container(
      width: style.size,
      height: style.size,
      decoration: ShapeDecoration(
        color: bgColor,
        shape: effectiveShape,
      ),
      child: Center(
        child: ClipPath(
          clipper: _AvatarClipper(shape: shape, style: style),
          child: content,
        ),
      ),
    );

    if (onTap != null && !disabled) {
      return InkWell(
        onTap: onTap,
        borderRadius: _getBorderRadius(effectiveShape),
        child: avatar,
      );
    }

    return avatar;
  }

  BorderRadiusGeometry? _getBorderRadius(ShapeBorder? shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius;
    }
    return null;
  }
}

/// Internal clipper for avatar shapes.
class _AvatarClipper extends CustomClipper<Path> {
  final AvatarShape shape;
  final AvatarStyle style;

  const _AvatarClipper({
    required this.shape,
    required this.style,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = style.size / 2;

    switch (shape) {
      case AvatarShape.circular:
        path.addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ));
        break;
      case AvatarShape.rounded:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(8),
        ));
        break;
      case AvatarShape.square:
        path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
        break;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
