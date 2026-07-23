import 'package:flutter/material.dart';

/// Dialog to confirm deleting a family
class DeleteFamilyDialog extends StatelessWidget {
  final String familyName;
  final int memberCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteFamilyDialog({
    super.key,
    required this.familyName,
    required this.memberCount,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(Icons.warning, color: Colors.red.shade700),
          const SizedBox(width: 8),
          const Text('Delete Family?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to delete "$familyName"?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This action is permanent and cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This will permanently delete:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• $memberCount member(s)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade600,
                  ),
                ),
                const Text(
                  '• All transactions and data',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade600,
                  ),
                ),
                const Text(
                  '• All accounts and categories',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
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
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Delete'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Show the dialog
  static Future<bool?> show(
    BuildContext context, {
    required String familyName,
    required int memberCount,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteFamilyDialog(
        familyName: familyName,
        memberCount: memberCount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
