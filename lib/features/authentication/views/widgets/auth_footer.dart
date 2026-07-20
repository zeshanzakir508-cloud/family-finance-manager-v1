import 'package:flutter/material.dart';

/// Authentication footer widget with text and action button.
class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          child: Text(
            actionText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
