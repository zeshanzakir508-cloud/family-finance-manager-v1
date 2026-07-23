import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../../enums/transaction_type.dart';
import '../../enums/recurring_frequency.dart';
import '../../constants/transaction_constants.dart';

/// Add transaction page
class AddTransactionPage extends ConsumerStatefulWidget {
  final String? presetAccountId;
  final String? presetCategoryId;
  final String? presetType;

  const AddTransactionPage({
    super.key,
    this.presetAccountId,
    this.presetCategoryId,
    this.presetType,
  });

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _fromAccountId;
  String? _toAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  RecurringFrequency _frequency = RecurringFrequency.monthly;
  DateTime? _recurringEndDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Apply presets
    if (widget.presetAccountId != null) {
      _selectedAccountId = widget.presetAccountId;
    }
    if (widget.presetCategoryId != null) {
      _selectedCategoryId = widget.presetCategoryId;
    }
    if (widget.presetType != null) {
      _type = TransactionType.parse(widget.presetType!);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(transactionActionsProvider);
      await actions.createTransaction(
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate,
        type: _type,
        accountId: _selectedAccountId ?? '',
        categoryId: _type == TransactionType.transfer ? null : _selectedCategoryId,
        fromAccountId: _type == TransactionType.transfer ? _fromAccountId : null,
        toAccountId: _type == TransactionType.transfer ? _toAccountId : null,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        isRecurring: _isRecurring,
        frequency: _isRecurring ? _frequency : null,
        recurringEndDate: _isRecurring ? _recurringEndDate : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction created successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create transaction: $e')),
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
    final accounts = ref.watch(activeAccountsProvider);
    final categories = ref.watch(activeCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTransaction,
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
                  validator: (value) {
                    final actions = ref.read(transactionActionsProvider);
                    return null; // Validation handled by controller
                  },
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
                // Account selection
                if (_type != TransactionType.transfer)
                  _buildAccountSelector('Account', _selectedAccountId, (id) {
                    setState(() => _selectedAccountId = id);
                  }),
                // Transfer accounts
                if (_type == TransactionType.transfer) ...[
                  _buildAccountSelector('From Account', _fromAccountId, (id) {
                    setState(() => _fromAccountId = id);
                  }, excludeId: _toAccountId),
                  const SizedBox(height: 12),
                  _buildAccountSelector('To Account', _toAccountId, (id) {
                    setState(() => _toAccountId = id);
                  }, excludeId: _fromAccountId),
                ],
                const SizedBox(height: 16),
                // Category selection
                if (_type != TransactionType.transfer)
                  _buildCategorySelector('Category', _selectedCategoryId, (id) {
                    setState(() => _selectedCategoryId = id);
                  }),
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
                const SizedBox(height: 16),
                // Recurring toggle
                SwitchListTile(
                  title: const Text('Recurring Transaction'),
                  subtitle: const Text('Repeat this transaction regularly'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                if (_isRecurring) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<RecurringFrequency>(
                    value: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: RecurringFrequency.allFrequencies.map((freq) {
                      return DropdownMenuItem(
                        value: freq,
                        child: Text(freq.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _frequency = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('End Date (Optional)'),
                    subtitle: _recurringEndDate != null
                        ? Text(_formatDate(_recurringEndDate!))
                        : const Text('No end date'),
                    onTap: _selectRecurringEndDate,
                    tileColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSelector(
    String label,
    String? selectedId,
    Function(String) onChanged, {
    String? excludeId,
  }) {
    final accounts = ref.watch(activeAccountsProvider);
    final availableAccounts = excludeId != null
        ? accounts.where((a) => a.id != excludeId).toList()
        : accounts;

    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      hint: const Text('Select account'),
      items: availableAccounts.map((account) {
        return DropdownMenuItem(
          value: account.id,
          child: Row(
            children: [
              Text(account.iconEmoji),
              const SizedBox(width: 8),
              Text(account.name),
              const Spacer(),
              Text(
                account.formattedBalance,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  Widget _buildCategorySelector(
    String label,
    String? selectedId,
    Function(String) onChanged,
  ) {
    final categories = ref.watch(activeCategoriesProvider);

    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      hint: const Text('Select category'),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Row(
            children: [
              Text(category.iconEmoji),
              const SizedBox(width: 8),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
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

  Future<void> _selectRecurringEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _recurringEndDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null) {
      setState(() => _recurringEndDate = date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
