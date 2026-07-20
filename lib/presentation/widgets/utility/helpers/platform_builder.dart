// lib/presentation/widgets/utility/helpers/platform_builder.dart

import 'package:flutter/material.dart';

import '../enums/platform_type.dart';

/// Helper class for platform-specific building.
///
/// This class provides methods for building platform-specific widgets.
///
/// Example:
/// ```dart
/// final widget = PlatformBuilder.build(
///   context: context,
///   android: AndroidWidget(),
///   ios: IosWidget(),
///   default: DefaultWidget(),
/// );
/// ```
abstract final class PlatformHelper {
  /// Returns the current platform type.
  static PlatformType getPlatform(BuildContext context) {
    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.android:
        return PlatformType.android;
      case TargetPlatform.iOS:
        return PlatformType.ios;
      case TargetPlatform.windows:
        return PlatformType.windows;
      case TargetPlatform.linux:
        return PlatformType.linux;
      case TargetPlatform.macOS:
        return PlatformType.macos;
      case TargetPlatform.fuchsia:
        return PlatformType.fuchsia;
      default:
        return PlatformType.unknown;
    }
  }

  /// Returns true if the current platform is Android.
  static bool isAndroid(BuildContext context) {
    return getPlatform(context) == PlatformType.android;
  }

  /// Returns true if the current platform is iOS.
  static bool isIos(BuildContext context) {
    return getPlatform(context) == PlatformType.ios;
  }

  /// Returns true if the current platform is mobile (Android or iOS).
  static bool isMobilePlatform(BuildContext context) {
    final platform = getPlatform(context);
    return platform == PlatformType.android || platform == PlatformType.ios;
  }

  /// Returns true if the current platform is desktop.
  static bool isDesktopPlatform(BuildContext context) {
    final platform = getPlatform(context);
    return platform == PlatformType.windows ||
        platform == PlatformType.linux ||
        platform == PlatformType.macos;
  }

  /// Returns the appropriate widget based on the current platform.
  static Widget build({
    required BuildContext context,
    Widget? android,
    Widget? ios,
    Widget? windows,
    Widget? linux,
    Widget? macos,
    Widget? web,
    Widget? fuchsia,
    required Widget defaultWidget,
  }) {
    final platform = getPlatform(context);

    switch (platform) {
      case PlatformType.android:
        return android ?? defaultWidget;
      case PlatformType.ios:
        return ios ?? defaultWidget;
      case PlatformType.windows:
        return windows ?? defaultWidget;
      case PlatformType.linux:
        return linux ?? defaultWidget;
      case PlatformType.macos:
        return macos ?? defaultWidget;
      case PlatformType.web:
        return web ?? defaultWidget;
      case PlatformType.fuchsia:
        return fuchsia ?? defaultWidget;
      case PlatformType.unknown:
        return defaultWidget;
    }
  }
}
