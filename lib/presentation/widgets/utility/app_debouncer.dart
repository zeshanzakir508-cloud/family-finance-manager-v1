// lib/presentation/widgets/utility/app_debouncer.dart

import 'dart:async';

import 'package:flutter/material.dart';

/// A debouncer for limiting the frequency of calls.
///
/// This class provides a standardized way to debounce function calls.
///
/// Example:
/// ```dart
/// final debouncer = AppDebouncer(duration: Duration(milliseconds: 300));
///
/// void onSearchChanged(String query) {
///   debouncer.call(() {
///     search(query);
///   });
/// }
/// ```
class AppDebouncer {
  /// The duration to wait before executing.
  final Duration duration;

  Timer? _timer;

  /// Creates a new [AppDebouncer].
  AppDebouncer({this.duration = const Duration(milliseconds: 300)});

  /// Calls the function after the debounce duration.
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels the pending call.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes the debouncer.
  void dispose() {
    cancel();
  }
}
