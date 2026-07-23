import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/recurring_transaction_card.dart';

/// Recurring transactions page
class RecurringTransactionsPage extends ConsumerStatefulWidget {
  const RecurringTransactionsPage({super.key});

  @override
  ConsumerState<RecurringTransactionsPage> createState() => _RecurringTransactionsPageState();
}

class _RecurringTransactionsPageState extends ConsumerState<RecurringTransactionsPage> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurring = ref.watch(recurringTransactionsProvider);
    final isLoading = ref.watch(transactionsLoadingProvider);
    final actions = ref.watch(transactionActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : () => actions.refresh(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recurring.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.repeat,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recurring transactions',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a recurring transaction from the add transaction page',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recurring.length,
                  itemBuilder: (context, index) {
                    final transaction = recurring[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RecurringTransactionCard(
                        transaction: transaction,
                        onEdit: () => context.goToEditTransaction(transaction.id),
                        onDelete: () => _showDeleteDialog(transaction, actions),
                        onToggle: () => _toggleRecurring(transaction, actions),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDeleteDialog(TransactionModel transaction, TransactionActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recurring Transaction'),
        content: Text('Are you sure you want to delete this recurring transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.deleteRecurringTransaction(transaction.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recurring transaction deleted')),
                  );
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

  void _toggleRecurring(TransactionModel transaction, TransactionActions actions) async {
    try {
      await actions.updateRecurringTransaction(
        transactionId: transaction.id,
        isActive: !transaction.isActive,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              transaction.isActive 
                  ? 'Recurring transaction paused' 
                  : 'Recurring transaction resumed',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }
}
