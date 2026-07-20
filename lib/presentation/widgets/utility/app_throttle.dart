// lib/presentation/widgets/utility/app_throttle.dart

import 'dart:async';

import 'package:flutter/material.dart';

/// A throttle for limiting the rate of calls.
///
/// This class provides a standardized way to throttle function calls.
///
/// Example:
/// ```dart
/// final throttle = AppThrottle(duration: Duration(seconds: 1));
///
/// void onButtonPressed() {
///   throttle.call(() {
///     submitForm();
///   });
/// }
/// ```
class AppThrottle {
  /// The duration to wait between calls.
  final Duration duration;

  Timer? _timer;
  bool _isThrottled = false;

  /// Creates a new [AppThrottle].
  AppThrottle({this.duration = const Duration(seconds: 1)});

  /// Calls the function if not throttled.
  void call(VoidCallback action) {
    if (_isThrottled) return;

    _isThrottled = true;
    action();

    _timer?.cancel();
    _timer = Timer(duration, () {
      _isThrottled = false;
    });
  }

  /// Cancels the throttle.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isThrottled = false;
  }

  /// Disposes the throttle.
  void dispose() {
    cancel();
  }
}
