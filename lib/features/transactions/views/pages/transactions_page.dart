import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../../enums/transaction_type.dart';
import '../../enums/transaction_sort.dart';
import '../sections/transaction_summary_section.dart';
import '../sections/transactions_list_section.dart';
import '../widgets/transaction_filter_bar.dart';

/// Transactions page showing list of transactions with summary
class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(transactionActionsProvider).setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(transactionControllerProvider);
    final actions = ref.watch(transactionActionsProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final isLoading = ref.watch(transactionsLoadingProvider);
    final error = ref.watch(transactionsErrorProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);
    final netIncome = ref.watch(netIncomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : () => actions.refresh(),
          ),
          PopupMenuButton<TransactionSort>(
            onSelected: (sort) => actions.setSortOption(sort),
            itemBuilder: (context) => TransactionSort.allSorts.map((sort) {
              return PopupMenuItem(
                value: sort,
                child: Text(sort.displayName),
              );
            }).toList(),
            child: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: Icon(Icons.filter_list),
              ),
            ),
          ),
          // Summary section
          TransactionSummarySection(
            income: totalIncome,
            expenses: totalExpenses,
            netIncome: netIncome,
          ),
          const SizedBox(height: 8),
          // Filter bar
          TransactionFilterBar(
            currentType: controller.filterType,
            onTypeFilter: actions.setFilterType,
            onClearFilters: actions.clearFilters,
          ),
          const SizedBox(height: 8),
          // Transactions list
          Expanded(
            child: error != null
                ? Center(
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
                  )
                : isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TransactionsListSection(
                        transactions: filteredTransactions,
                        onTransactionTap: (transaction) => 
                            context.goToTransactionDetails(transaction.id),
                        onEdit: (transaction) => 
                            context.goToEditTransaction(transaction.id),
                        onDelete: (transaction) => 
                            _showDeleteDialog(transaction, actions),
                        onDuplicate: (transaction) => 
                            _duplicateTransaction(transaction, actions),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goToAddTransaction(),
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
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
