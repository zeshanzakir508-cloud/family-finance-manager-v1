// lib/presentation/widgets/utility/app_keyboard_dismiss.dart

import 'package:flutter/material.dart';

/// A widget that dismisses the keyboard on tap outside.
///
/// This widget provides a standardized way to dismiss the keyboard
/// by tapping outside the input area.
///
/// Example:
/// ```dart
/// AppKeyboardDismiss(
///   child: MyForm(),
/// )
/// ```
class AppKeyboardDismiss extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Whether to dismiss the keyboard on tap.
  final bool dismissOnTap;

  /// Creates a new [AppKeyboardDismiss].
  const AppKeyboardDismiss({
    super.key,
    required this.child,
    this.dismissOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!dismissOnTap) return child;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
