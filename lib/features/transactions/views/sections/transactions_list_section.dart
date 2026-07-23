import 'package:flutter/material.dart';
import '../widgets/transaction_card.dart';

/// Transactions list section showing list of transactions
class TransactionsListSection extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel) onTransactionTap;
  final Function(TransactionModel)? onEdit;
  final Function(TransactionModel)? onDelete;
  final Function(TransactionModel)? onDuplicate;

  const TransactionsListSection({
    super.key,
    required this.transactions,
    required this.onTransactionTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first transaction to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TransactionCard(
            transaction: transaction,
            onTap: () => onTransactionTap(transaction),
            onEdit: onEdit != null ? () => onEdit!(transaction) : null,
            onDelete: onDelete != null ? () => onDelete!(transaction) : null,
            onDuplicate: onDuplicate != null ? () => onDuplicate!(transaction) : null,
          ),
        );
      },
    );
  }
}
