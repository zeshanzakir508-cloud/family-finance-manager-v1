import 'package:flutter/material.dart';

/// Page indicator widget with dots
class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? dotSize;
  final double? activeDotSize;
  final double? spacing;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.activeDotSize,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing ?? 4),
          width: isActive ? (activeDotSize ?? dotSize ?? 24) : (dotSize ?? 8),
          height: isActive ? (activeDotSize ?? dotSize ?? 8) : (dotSize ?? 8),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor ?? Colors.blue
                : inactiveColor ?? Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
