import 'package:flutter/material.dart';

/// Dialog to confirm ownership transfer
class OwnershipTransferDialog extends StatelessWidget {
  final String currentOwnerName;
  final String newOwnerName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const OwnershipTransferDialog({
    super.key,
    required this.currentOwnerName,
    required this.newOwnerName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Transfer Ownership?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer ownership from $currentOwnerName to $newOwnerName?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What will happen:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• $currentOwnerName will become a Moderator',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                  ),
                ),
                Text(
                  '• $newOwnerName will become the new Owner',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                  ),
                ),
                const Text(
                  '• All settings and data remain unchanged',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This action can be reversed by the new owner.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Transfer'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Show the dialog
  static Future<bool?> show(
    BuildContext context, {
    required String currentOwnerName,
    required String newOwnerName,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OwnershipTransferDialog(
        currentOwnerName: currentOwnerName,
        newOwnerName: newOwnerName,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
