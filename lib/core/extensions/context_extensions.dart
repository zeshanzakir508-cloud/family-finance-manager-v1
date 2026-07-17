import 'package:flutter/material.dart';

/// ============================================================================
/// Family Finance Manager
/// BuildContext Extensions
/// ----------------------------------------------------------------------------
/// Common shortcuts for Theme, MediaQuery, Navigation and SnackBars.
/// ============================================================================

extension ContextExtensions on BuildContext {
  //--------------------------------------------------------------------------
  // Theme
  //--------------------------------------------------------------------------

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  //---------------------------------------------------------------------------
  // MediaQuery
  //---------------------------------------------------------------------------

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get width => screenSize.width;

  double get height => screenSize.height;

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;

  //---------------------------------------------------------------------------
  // Navigation
  //---------------------------------------------------------------------------

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
  ) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
    );
  }

  //---------------------------------------------------------------------------
  // SnackBar
  //---------------------------------------------------------------------------

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
  }

  //---------------------------------------------------------------------------
  // Focus
  //---------------------------------------------------------------------------

  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}
