import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../../enums/transaction_type.dart';

/// Edit transaction page
class EditTransactionPage extends ConsumerStatefulWidget {
  final String transactionId;

  const EditTransactionPage({super.key, required this.transactionId});

  @override
  ConsumerState<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends ConsumerState<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _fromAccountId;
  String? _toAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransaction();
    });
  }

  Future<void> _loadTransaction() async {
    final actions = ref.read(transactionActionsProvider);
    await actions.loadTransaction(widget.transactionId);
    
    final transaction = ref.read(selectedTransactionProvider);
    if (transaction != null) {
      _amountController.text = transaction.amount.toString();
      _noteController.text = transaction.note ?? '';
      _type = transaction.type;
      _selectedAccountId = transaction.accountId;
      _selectedCategoryId = transaction.categoryId;
      _fromAccountId = transaction.fromAccountId;
      _toAccountId = transaction.toAccountId;
      _selectedDate = transaction.date;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(transactionActionsProvider);
      await actions.updateTransaction(
        transactionId: widget.transactionId,
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate,
        type: _type,
        accountId: _selectedAccountId,
        categoryId: _type == TransactionType.transfer ? null : _selectedCategoryId,
        fromAccountId: _type == TransactionType.transfer ? _fromAccountId : null,
        toAccountId: _type == TransactionType.transfer ? _toAccountId : null,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction updated successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update transaction: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(selectedTransactionProvider);
    final isLoading = ref.watch(transactionsLoadingProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Transaction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Transaction')),
        body: const Center(child: Text('Transaction not found')),
      );
    }

    final accounts = ref.watch(activeAccountsProvider);
    final categories = ref.watch(activeCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateTransaction,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Transaction type
                SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(
                      value: TransactionType.income,
                      label: const Text('Income'),
                      icon: const Icon(Icons.arrow_upward, size: 16),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: const Text('Expense'),
                      icon: const Icon(Icons.arrow_downward, size: 16),
                    ),
                    ButtonSegment(
                      value: TransactionType.transfer,
                      label: const Text('Transfer'),
                      icon: const Icon(Icons.swap_horiz, size: 16),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (Set<TransactionType> selection) {
                    setState(() {
                      _type = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(_formatDate(_selectedDate)),
                  onTap: _selectDate,
                  tileColor: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                // Account selection (simplified - reuse from add page)
                // ... similar to add page
                const SizedBox(height: 16),
                // Note
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (Optional)',
                    hintText: 'Add a note',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
