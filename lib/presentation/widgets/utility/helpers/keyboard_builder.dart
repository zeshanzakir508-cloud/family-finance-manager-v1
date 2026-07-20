// lib/presentation/widgets/utility/helpers/keyboard_builder.dart

import 'package:flutter/material.dart';

/// Helper class for keyboard-related operations.
///
/// This class provides methods for handling keyboard visibility
/// and insets.
///
/// Example:
/// ```dart
/// final isVisible = KeyboardHelper.isVisible(context);
/// ```
abstract final class KeyboardHelper {
  /// Returns true if the keyboard is visible.
  static bool isVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Returns the keyboard height.
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Dismisses the keyboard.
  static void dismiss(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Returns a widget that listens to keyboard changes.
  static Widget listener({
    required Widget child,
    required void Function(bool isVisible, double height) onChanged,
  }) {
    return Builder(
      builder: (context) {
        final isVisible = KeyboardHelper.isVisible(context);
        final height = KeyboardHelper.getHeight(context);
        onChanged(isVisible, height);
        return child;
      },
    );
  }
}
