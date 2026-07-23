import 'package:flutter/material.dart';

/// Dialog to confirm merging categories
class MergeCategoryDialog extends StatelessWidget {
  final String sourceCategoryName;
  final String targetCategoryName;
  final int transactionCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const MergeCategoryDialog({
    super.key,
    required this.sourceCategoryName,
    required this.targetCategoryName,
    required this.transactionCount,
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
          Icon(Icons.merge_type, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          const Text('Merge Categories?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merge "$sourceCategoryName" into "$targetCategoryName"?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
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
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'What will happen:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '• $transactionCount transaction(s) will be moved to "$targetCategoryName"',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                  ),
                ),
                Text(
                  '• "$sourceCategoryName" will be deleted',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
                  ),
                ),
                const Text(
                  '• This action cannot be undone',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade600,
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
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Merge'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Show the dialog
  static Future<bool?> show(
    BuildContext context, {
    required String sourceCategoryName,
    required String targetCategoryName,
    required int transactionCount,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MergeCategoryDialog(
        sourceCategoryName: sourceCategoryName,
        targetCategoryName: targetCategoryName,
        transactionCount: transactionCount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
