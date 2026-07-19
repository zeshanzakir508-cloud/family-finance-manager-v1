// lib/presentation/widgets/buttons/widgets/button_content.dart

import 'package:flutter/material.dart';

import '../constants/button_constants.dart';

/// A reusable widget that displays button content with optional icons.
///
/// This widget handles the layout of button content including:
/// - Optional leading icon
/// - Label text
/// - Optional trailing icon
///
/// Example:
/// ```dart
/// ButtonContent(
///   label: 'Submit',
///   leadingIcon: Icons.send,
///   textStyle: TextStyle(color: Colors.white),
///   iconColor: Colors.white,
///   iconSize: 20,
/// )
/// ```
class ButtonContent extends StatelessWidget {
  /// The label text to display.
  final String label;

  /// Optional leading icon to display before the label.
  final IconData? leadingIcon;

  /// Optional trailing icon to display after the label.
  final IconData? trailingIcon;

  /// The text style for the label.
  final TextStyle? textStyle;

  /// The color of the icons.
  final Color? iconColor;

  /// The size of the icons.
  final double? iconSize;

  /// Whether the content is in a loading state.
  final bool isLoading;

  /// Creates a new [ButtonContent].
  const ButtonContent({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    if (leadingIcon != null) {
      children.add(
        Icon(
          leadingIcon,
          color: iconColor,
          size: iconSize ?? ButtonConstants.iconSizeMedium,
        ),
      );
      children.add(
        const SizedBox(width: ButtonConstants.iconTextSpacing),
      );
    }

    children.add(
      Text(
        label,
        style: textStyle,
      ),
    );

    if (trailingIcon != null) {
      children.add(
        const SizedBox(width: ButtonConstants.iconTextSpacing),
      );
      children.add(
        Icon(
          trailingIcon,
          color: iconColor,
          size: iconSize ?? ButtonConstants.iconSizeMedium,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
