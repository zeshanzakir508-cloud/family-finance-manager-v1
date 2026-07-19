// lib/presentation/widgets/dialogs/app_dialog.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../buttons/app_button.dart';
import 'enums/dialog_type.dart';
import 'helpers/dialog_icon_builder.dart';

/// A customizable base dialog widget for the application.
///
/// This widget provides a standardized dialog with consistent styling,
/// supporting multiple types, custom content, and action buttons.
/// All dialogs in the app (success, error, warning, info, confirmation)
/// should reuse this widget.
///
/// Example:
/// ```dart
/// AppDialog(
///   type: DialogType.success,
///   title: 'Success!',
///   message: 'Your changes have been saved.',
///   confirmText: 'OK',
///   onConfirm: () => _handleConfirm(),
/// )
/// ```
class AppDialog extends StatelessWidget {
  /// The type of dialog (success, error, warning, info, confirmation).
  final DialogType type;

  /// The title text displayed at the top of the dialog.
  final String title;

  /// The main message text displayed below the title.
  final String message;

  /// Optional custom icon override.
  final Widget? icon;

  /// Optional custom content widget displayed below the message.
  final Widget? content;

  /// Text for the confirm button. Defaults to 'OK'.
  final String? confirmText;

  /// Text for the cancel button. Defaults to 'Cancel'.
  final String? cancelText;

  /// Callback when the confirm button is pressed.
  final VoidCallback? onConfirm;

  /// Callback when the cancel button is pressed.
  final VoidCallback? onCancel;

  /// Whether to show the cancel button.
  final bool showCancelButton;

  /// Whether the dialog can be dismissed by tapping outside.
  final bool barrierDismissible;

  /// Custom icon color override.
  final Color? iconColor;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom content padding override.
  final EdgeInsetsGeometry? contentPadding;

  /// Maximum width of the dialog.
  final double? maxWidth;

  /// Whether the confirm action is destructive (uses danger button style).
  final bool isDestructive;

  /// Creates a new [AppDialog].
  const AppDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.icon,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = false,
    this.barrierDismissible = true,
    this.iconColor,
    this.backgroundColor,
    this.contentPadding,
    this.maxWidth,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = maxWidth ?? 480.0;
    final dialogWidth = math.min(screenWidth - 32, effectiveMaxWidth);

    return Dialog(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          padding: contentPadding ?? const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(context, colorScheme),
              const SizedBox(height: 16),
              _buildTitle(context, colorScheme),
              const SizedBox(height: 8),
              _buildMessage(context, colorScheme),
              if (content != null) ...[
                const SizedBox(height: 16),
                content!,
              ],
              const SizedBox(height: 24),
              _buildActions(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ColorScheme colorScheme) {
    final color = iconColor ?? _getDefaultIconColor(colorScheme);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: icon ??
          Icon(
            DialogIconBuilder.build(type),
            color: color,
            size: 48,
          ),
    );
  }

  Color _getDefaultIconColor(ColorScheme colorScheme) {
    switch (type) {
      case DialogType.success:
        return colorScheme.primary;
      case DialogType.info:
        return colorScheme.primary;
      case DialogType.warning:
        return colorScheme.tertiary;
      case DialogType.error:
        return colorScheme.error;
      case DialogType.confirmation:
        return colorScheme.secondary;
    }
  }

  Widget _buildTitle(BuildContext context, ColorScheme colorScheme) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, ColorScheme colorScheme) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme colorScheme) {
    final children = <Widget>[];

    if (showCancelButton) {
      children.add(
        Flexible(
          child: AppButton(
            label: cancelText ?? 'Cancel',
            onPressed: onCancel,
            variant: AppButtonVariant.text,
            size: AppButtonSize.medium,
          ),
        ),
      );
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Flexible(
        child: AppButton(
          label: confirmText ?? 'OK',
          onPressed: onConfirm,
          variant: isDestructive ? AppButtonVariant.danger : AppButtonVariant.primary,
          size: AppButtonSize.medium,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }
}
