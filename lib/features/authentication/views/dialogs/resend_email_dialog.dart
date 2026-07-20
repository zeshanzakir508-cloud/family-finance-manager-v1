import 'package:flutter/material.dart';

/// Resend verification email dialog.
class ResendEmailDialog extends StatelessWidget {
  final String email;
  final VoidCallback onConfirm;

  const ResendEmailDialog({
    super.key,
    required this.email,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resend Verification Email'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A new verification email will be sent to:',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please check your inbox and spam folder.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Resend'),
        ),
      ],
    );
  }
}

/// Shows the resend email dialog.
Future<bool?> showResendEmailDialog(
  BuildContext context, {
  required String email,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ResendEmailDialog(
      email: email,
      onConfirm: () => Navigator.pop(context, true),
    ),
  );
}
