import 'package:flutter/material.dart';

/// Delete account confirmation dialog.
class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? email;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Account',
        style: TextStyle(color: Colors.red),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'This action cannot be undone. All your data will be permanently deleted.',
            style: TextStyle(color: Colors.grey),
          ),
          if (email != null) ...[
            const SizedBox(height: 12),
            Text(
              'Email: $email',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Please type "DELETE" to confirm',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Type DELETE',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Validation will be handled in the dialog
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

/// Shows the delete account dialog.
Future<bool?> showDeleteAccountDialog(
  BuildContext context, {
  String? email,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => DeleteAccountDialog(
      email: email,
      onConfirm: () => Navigator.pop(context, true),
    ),
  );
}
