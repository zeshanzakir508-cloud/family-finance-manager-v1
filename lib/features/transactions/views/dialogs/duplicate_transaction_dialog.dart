import 'package:flutter/material.dart';

/// Dialog to confirm duplicating a transaction
class DuplicateTransactionDialog extends StatelessWidget {
  final String transactionDescription;
  final double amount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DuplicateTransactionDialog({
    super.key,
    required this.transactionDescription,
    required this.amount,
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
          Icon(Icons.copy, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          const Text('Duplicate Transaction?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to duplicate this transaction?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description: $transactionDescription',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Amount: \$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: amount >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'A new transaction will be created with the same details.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Text(
            'You can edit the duplicated transaction later.',
            style: TextStyle(
              fontSize: 14,
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
          child: const Text('Duplicate'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Show the dialog
  static Future<bool?> show(
    BuildContext context, {
    required String transactionDescription,
    required double amount,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DuplicateTransactionDialog(
        transactionDescription: transactionDescription,
        amount: amount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
