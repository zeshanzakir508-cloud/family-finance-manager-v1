// lib/presentation/widgets/buttons/widgets/button_loading_indicator.dart

import 'package:flutter/material.dart';

import '../constants/button_constants.dart';

/// A reusable loading indicator widget for buttons.
///
/// This widget displays a circular progress indicator with consistent
/// styling for button loading states.
///
/// Example:
/// ```dart
/// ButtonLoadingIndicator(
///   color: Colors.white,
///   size: 20,
///   strokeWidth: 2,
/// )
/// ```
class ButtonLoadingIndicator extends StatelessWidget {
  /// The color of the loading indicator.
  final Color color;

  /// The size of the loading indicator.
  final double size;

  /// The stroke width of the loading indicator.
  final double strokeWidth;

  /// Creates a new [ButtonLoadingIndicator].
  const ButtonLoadingIndicator({
    super.key,
    required this.color,
    this.size = ButtonConstants.loadingIndicatorSize,
    this.strokeWidth = ButtonConstants.loadingIndicatorStrokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
