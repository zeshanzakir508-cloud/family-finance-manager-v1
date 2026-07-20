// lib/presentation/widgets/utility/app_platform_builder.dart

import 'package:flutter/material.dart';

import 'enums/platform_type.dart';
import 'helpers/platform_builder.dart';

/// A platform-aware widget builder.
///
/// This widget provides a standardized platform-aware layout that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppPlatformBuilder(
///   android: AndroidWidget(),
///   ios: IosWidget(),
///   default: DefaultWidget(),
/// )
/// ```
class AppPlatformBuilder extends StatelessWidget {
  /// The widget for Android.
  final Widget? android;

  /// The widget for iOS.
  final Widget? ios;

  /// The widget for Windows.
  final Widget? windows;

  /// The widget for Linux.
  final Widget? linux;

  /// The widget for macOS.
  final Widget? macos;

  /// The widget for Web.
  final Widget? web;

  /// The widget for Fuchsia.
  final Widget? fuchsia;

  /// The default widget.
  final Widget defaultWidget;

  /// Creates a new [AppPlatformBuilder].
  const AppPlatformBuilder({
    super.key,
    this.android,
    this.ios,
    this.windows,
    this.linux,
    this.macos,
    this.web,
    this.fuchsia,
    required this.defaultWidget,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformHelper.build(
      context: context,
      android: android,
      ios: ios,
      windows: windows,
      linux: linux,
      macos: macos,
      web: web,
      fuchsia: fuchsia,
      defaultWidget: defaultWidget,
    );
  }
}
