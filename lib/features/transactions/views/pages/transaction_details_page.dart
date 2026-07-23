import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../../enums/transaction_type.dart';
import '../widgets/transaction_type_chip.dart';

/// Transaction details page
class TransactionDetailsPage extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailsPage({super.key, required this.transactionId});

  @override
  ConsumerState<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends ConsumerState<TransactionDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionActionsProvider).loadTransaction(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(selectedTransactionProvider);
    final isLoading = ref.watch(transactionsLoadingProvider);
    final error = ref.watch(transactionsErrorProvider);
    final actions = ref.watch(transactionActionsProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 8),
              Text(error),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => actions.refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: Text('Transaction not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.goToEditTransaction(transaction.id),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'duplicate':
                  _duplicateTransaction(transaction, actions);
                  break;
                case 'delete':
                  _showDeleteDialog(transaction, actions);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Text('Duplicate'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount
            Center(
              child: Column(
                children: [
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getAmountColor(transaction.type),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TransactionTypeChip(type: transaction.type),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Details
            _DetailTile(
              icon: Icons.category,
              label: 'Category',
              value: transaction.categoryName ?? 'N/A',
            ),
            const Divider(),
            _DetailTile(
              icon: Icons.account_balance_wallet,
              label: 'Account',
              value: transaction.accountName ?? 'N/A',
            ),
            if (transaction.type == TransactionType.transfer) ...[
              const Divider(),
              _DetailTile(
                icon: Icons.arrow_forward,
                label: 'From',
                value: transaction.fromAccountName ?? 'N/A',
              ),
              const Divider(),
              _DetailTile(
                icon: Icons.arrow_back,
                label: 'To',
                value: transaction.toAccountName ?? 'N/A',
              ),
            ],
            const Divider(),
            _DetailTile(
              icon: Icons.calendar_today,
              label: 'Date',
              value: _formatDate(transaction.date),
            ),
            const Divider(),
            if (transaction.note != null && transaction.note!.isNotEmpty) ...[
              _DetailTile(
                icon: Icons.note,
                label: 'Note',
                value: transaction.note!,
              ),
              const Divider(),
            ],
            _DetailTile(
              icon: Icons.info_outline,
              label: 'Status',
              value: transaction.status.displayName,
            ),
            if (transaction.isRecurring) ...[
              const Divider(),
              _DetailTile(
                icon: Icons.repeat,
                label: 'Recurring',
                value: 'Yes (${transaction.frequency?.displayName ?? 'N/A'})',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(TransactionModel transaction, TransactionActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.deleteTransaction(transaction.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction deleted successfully')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _duplicateTransaction(TransactionModel transaction, TransactionActions actions) async {
    try {
      await actions.duplicateTransaction(transaction.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction duplicated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to duplicate: $e')),
        );
      }
    }
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
