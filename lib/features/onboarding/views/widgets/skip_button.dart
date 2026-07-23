import 'package:flutter/material.dart';

/// Skip button widget for onboarding
class OnboardingSkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const OnboardingSkipButton({
    super.key,
    required this.onPressed,
    this.text = 'Skip',
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
      child: Text(text),
    );
  }
}
