import 'package:flutter/material.dart';

enum OnboardingButtonType {
  primary,
  secondary,
  outline,
  text,
}

/// Reusable onboarding button widget
class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final OnboardingButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = OnboardingButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: _getButtonStyle(context),
      child: _buildChild(),
    );

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }
    if (height != null) {
      button = SizedBox(height: height, child: button);
    }

    return button;
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    switch (type) {
      case OnboardingButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        );
      case OnboardingButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        );
      case OnboardingButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.shade300),
          ),
          elevation: 0,
        );
      case OnboardingButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
    }
  }
}
