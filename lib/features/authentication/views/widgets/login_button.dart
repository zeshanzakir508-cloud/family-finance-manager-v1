import 'package:flutter/material.dart';

/// Custom login button widget.
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final Widget? icon;

  const LoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text = 'Login',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 12),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
