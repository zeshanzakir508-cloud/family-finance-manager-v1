import 'package:flutter/material.dart';

/// Resend timer widget for OTP resend cooldown.
class ResendTimer extends StatelessWidget {
  final bool canResend;
  final int remainingSeconds;
  final VoidCallback onResend;

  const ResendTimer({
    super.key,
    required this.canResend,
    required this.remainingSeconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        if (canResend)
          TextButton(
            onPressed: onResend,
            child: const Text('Resend'),
          )
        else
          Text(
            'Resend in ${remainingSeconds}s',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
