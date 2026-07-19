// lib/presentation/widgets/dialogs/app_confirmation_dialog.dart

import 'package:flutter/material.dart';

import 'app_dialog.dart';
import 'enums/dialog_type.dart';

/// A specialized confirmation dialog built on top of [AppDialog].
///
/// This widget should be used for confirmation scenarios such as:
/// - Delete item
/// - Logout
/// - Remove family member
/// - Leave family
/// - Discard changes
/// - Reset settings
/// - Any Yes/No confirmation
///
/// Example:
/// ```dart
/// AppConfirmationDialog(
///   title: 'Delete Item?',
///   message: 'Are you sure you want to delete this item? This action cannot be undone.',
///   confirmText: 'Delete',
///   isDestructive: true,
///   onConfirm: () => _deleteItem(),
/// )
/// ```
class AppConfirmationDialog extends StatelessWidget {
  /// The title of the confirmation dialog.
  final String title;

  /// The message displayed in the confirmation dialog.
  final String message;

  /// Optional custom icon override.
  final Widget? icon;

  /// Optional custom content widget displayed below the message.
  final Widget? content;

  /// Text for the confirm button. Defaults to 'Confirm'.
  final String? confirmText;

  /// Text for the cancel button. Defaults to 'Cancel'.
  final String? cancelText;

  /// Callback when the confirm button is pressed.
  final VoidCallback? onConfirm;

  /// Callback when the cancel button is pressed.
  final VoidCallback? onCancel;

  /// Whether the dialog can be dismissed by tapping outside.
  final bool barrierDismissible;

  /// Whether the confirm action is destructive (uses danger button style).
  final bool isDestructive;

  /// Custom icon color override.
  final Color? iconColor;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom content padding override.
  final EdgeInsetsGeometry? contentPadding;

  /// Maximum width of the dialog.
  final double? maxWidth;

  /// Creates a new [AppConfirmationDialog].
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.isDestructive = false,
    this.iconColor,
    this.backgroundColor,
    this.contentPadding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      type: DialogType.confirmation,
      title: title,
      message: message,
      icon: icon,
      content: content,
      confirmText: confirmText ?? 'Confirm',
      cancelText: cancelText ?? 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
      showCancelButton: true,
      barrierDismissible: barrierDismissible,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      maxWidth: maxWidth,
      isDestructive: isDestructive,
    );
  }
}
