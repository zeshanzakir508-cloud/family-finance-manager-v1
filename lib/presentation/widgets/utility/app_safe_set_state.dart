// lib/presentation/widgets/utility/app_safe_set_state.dart

import 'package:flutter/material.dart';

/// A utility for safely calling setState.
///
/// This class provides a standardized way to call setState
/// safely without checking mounted.
///
/// Example:
/// ```dart
/// class MyWidget extends State<MyStatefulWidget> {
///   final safeSetState = AppSafeSetState();
///
///   void updateData() {
///     safeSetState.call(this, () {
///       _data = newData;
///     });
///   }
/// }
/// ```
class AppSafeSetState {
  /// Calls setState safely.
  void call(State state, VoidCallback fn) {
    if (state.mounted) {
      state.setState(fn);
    }
  }

  /// Calls setState safely with a delay.
  void delayed(State state, VoidCallback fn, Duration duration) {
    Future.delayed(duration, () {
      if (state.mounted) {
        state.setState(fn);
      }
    });
  }

  /// Calls setState safely after a frame.
  void afterFrame(State state, VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.mounted) {
        state.setState(fn);
      }
    });
  }
}
