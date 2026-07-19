// lib/presentation/widgets/buttons/app_fab.dart

import 'package:flutter/material.dart';

import 'enums/app_fab_size.dart';
import 'builders/fab_style_builder.dart';
import 'constants/button_constants.dart';

/// A floating action button with consistent styling.
///
/// This widget provides a standardized FAB that follows the application's
/// design system with support for multiple variants and sizes.
///
/// Example:
/// ```dart
/// AppFAB(
///   icon: Icons.add,
///   onPressed: () => showCreateDialog(),
///   size: AppFabSize.regular,
/// )
/// ```
class AppFAB extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Callback when the FAB is pressed.
  final VoidCallback? onPressed;

  /// The size of the FAB.
  final AppFabSize size;

  /// Whether the FAB is disabled.
  final bool isDisabled;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom foreground color.
  final Color? foregroundColor;

  /// Custom elevation.
  final double? elevation;

  /// Additional tooltip text.
  final String? tooltip;

  /// Creates a new [AppFAB].
  const AppFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppFabSize.regular,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onPressed != null;

    final style = FabStyleBuilder.build(
      context: context,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
    );

    return FloatingActionButton(
      onPressed: isEnabled ? onPressed : null,
      child: Icon(icon),
      style: style,
      tooltip: tooltip,
      mini: size == AppFabSize.small,
    );
  }
}
