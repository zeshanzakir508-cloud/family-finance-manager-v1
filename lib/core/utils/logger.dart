import 'package:flutter/foundation.dart';

/// ============================================================================
/// Family Finance Manager
/// Logger
/// ----------------------------------------------------------------------------
/// Centralized logging utility.
///
/// Rules:
/// - Never use print().
/// - Never use debugPrint() directly.
/// - Always use AppLogger.
/// ============================================================================

class AppLogger {
  AppLogger._();

  static void debug(
    Object? message, {
    String? tag,
  }) {
    if (!kDebugMode) return;

    debugPrint(_buildMessage(
      level: 'DEBUG',
      tag: tag,
      message: message,
    ));
  }

  static void info(
    Object? message, {
    String? tag,
  }) {
    if (!kDebugMode) return;

    debugPrint(_buildMessage(
      level: 'INFO',
      tag: tag,
      message: message,
    ));
  }

  static void warning(
    Object? message, {
    String? tag,
  }) {
    if (!kDebugMode) return;

    debugPrint(_buildMessage(
      level: 'WARNING',
      tag: tag,
      message: message,
    ));
  }

  static void error(
    Object? message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    debugPrint(_buildMessage(
      level: 'ERROR',
      tag: tag,
      message: message,
    ));

    if (error != null) {
      debugPrint('Error: $error');
    }

    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  static String _buildMessage({
    required String level,
    required Object? message,
    String? tag,
  }) {
    final buffer = StringBuffer();

    buffer.write('[$level]');

    if (tag != null && tag.isNotEmpty) {
      buffer.write('[$tag]');
    }

    buffer.write(' $message');

    return buffer.toString();
  }
}
