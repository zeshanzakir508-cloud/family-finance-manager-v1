import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/auth_routes.dart';

/// Session expired dialog.
class SessionExpiredDialog extends StatelessWidget {
  final VoidCallback? onLogin;

  const SessionExpiredDialog({
    super.key,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Session Expired'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.timer_off,
            size: 48,
            color: Colors.orange,
          ),
          SizedBox(height: 16),
          Text(
            'Your session has expired.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please login again to continue using the app.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onLogin != null) {
              onLogin!();
            } else {
              context.go(AuthRoutes.login);
            }
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

/// Shows the session expired dialog.
Future<bool?> showSessionExpiredDialog(
  BuildContext context, {
  VoidCallback? onLogin,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => SessionExpiredDialog(
      onLogin: onLogin,
    ),
  );
}
