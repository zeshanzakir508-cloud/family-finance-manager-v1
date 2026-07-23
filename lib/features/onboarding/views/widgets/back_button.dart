import 'package:flutter/material.dart';

/// Back button widget for onboarding
class OnboardingBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const OnboardingBackButton({
    super.key,
    required this.onPressed,
    this.text = 'Back',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, size: 18),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
