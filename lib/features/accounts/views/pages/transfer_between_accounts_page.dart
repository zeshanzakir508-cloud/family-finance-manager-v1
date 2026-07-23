import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/account_provider.dart';
import '../widgets/account_selector.dart';

/// Transfer between accounts page
class TransferBetweenAccountsPage extends ConsumerStatefulWidget {
  final String? fromAccountId;
  final String? toAccountId;

  const TransferBetweenAccountsPage({
    super.key,
    this.fromAccountId,
    this.toAccountId,
  });

  @override
  ConsumerState<TransferBetweenAccountsPage> createState() =>
      _TransferBetweenAccountsPageState();
}

class _TransferBetweenAccountsPageState
    extends ConsumerState<TransferBetweenAccountsPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  AccountModel? _fromAccount;
  AccountModel? _toAccount;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialAccounts();
  }

  void _loadInitialAccounts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accounts = ref.read(activeAccountsProvider);
      if (widget.fromAccountId != null) {
        _fromAccount = accounts.firstWhereOrNull(
          (a) => a.id == widget.fromAccountId,
        );
      }
      if (widget.toAccountId != null) {
        _toAccount = accounts.firstWhereOrNull(
          (a) => a.id == widget.toAccountId,
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _completeTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromAccount == null || _toAccount == null) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(accountActionsProvider);
      await actions.transfer(
        fromAccountId: _fromAccount!.id,
        toAccountId: _toAccount!.id,
        amount: double.parse(_amountController.text.trim()),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        date: _selectedDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transfer completed successfully! 💰')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete transfer: $e')),
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
    final isLoading = ref.watch(accountsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _completeTransfer,
            child: const Text('Transfer'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // From account
                    AccountSelector(
                      label: 'From Account',
                      accounts: accounts,
                      selectedAccount: _fromAccount,
                      onChanged: (account) {
                        setState(() => _fromAccount = account);
                      },
                      excludeId: _toAccount?.id,
                    ),
                    const SizedBox(height: 16),
                    // To account
                    AccountSelector(
                      label: 'To Account',
                      accounts: accounts,
                      selectedAccount: _toAccount,
                      onChanged: (account) {
                        setState(() => _toAccount = account);
                      },
                      excludeId: _fromAccount?.id,
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
                        final actions = ref.read(accountActionsProvider);
                        return actions.validateTransferAmount(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Note
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Note (Optional)',
                        hintText: 'Add a note for this transfer',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    // Date
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(_formatDate(_selectedDate)),
                      onTap: _selectDate,
                      tileColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Spacer(),
                    // Preview
                    if (_fromAccount != null && _toAccount != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _fromAccount!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward),
                                Text(
                                  _toAccount!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Amount:'),
                                Text(
                                  '\$${_amountController.text.isEmpty ? '0.00' : _amountController.text}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
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
