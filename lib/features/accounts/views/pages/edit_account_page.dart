import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/account_provider.dart';
import '../../constants/account_constants.dart';

/// Edit account page
class EditAccountPage extends ConsumerStatefulWidget {
  final String accountId;

  const EditAccountPage({super.key, required this.accountId});

  @override
  ConsumerState<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends ConsumerState<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _balanceController = TextEditingController();
  String _selectedIcon = 'wallet';
  String _selectedColor = '#4ECDC4';
  bool _isLoading = false;
  bool _canEditBalance = true;

  final List<String> _iconOptions = AccountConstants.accountIcons;
  final List<String> _colorOptions = AccountConstants.accountColors;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccount();
    });
  }

  Future<void> _loadAccount() async {
    final actions = ref.read(accountActionsProvider);
    await actions.loadAccount(widget.accountId);
    
    final account = ref.read(selectedAccountProvider);
    if (account != null) {
      _nameController.text = account.name;
      _descriptionController.text = account.description ?? '';
      _balanceController.text = account.openingBalance.toString();
      _selectedIcon = account.icon;
      _selectedColor = account.color;
      _canEditBalance = account.transactions.isEmpty; // Assuming transactions property exists
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _updateAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(accountActionsProvider);
      await actions.updateAccount(
        accountId: widget.accountId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        openingBalance: _canEditBalance
            ? double.parse(_balanceController.text.trim())
            : null,
        icon: _selectedIcon,
        color: _selectedColor,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account updated successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update account: $e')),
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
    final account = ref.watch(selectedAccountProvider);
    final isLoading = ref.watch(accountsLoadingProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Account')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Account')),
        body: const Center(child: Text('Account not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateAccount,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Account name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  hintText: 'Enter account name',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final actions = ref.read(accountActionsProvider);
                  return actions.validateName(value);
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add a brief description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Opening balance
              TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(
                  labelText: 'Opening Balance',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  enabled: _canEditBalance,
                  helperText: _canEditBalance
                      ? null
                      : 'Cannot edit balance after transactions exist',
                ),
                keyboardType: TextInputType.number,
                enabled: _canEditBalance,
                validator: (value) {
                  if (!_canEditBalance) return null;
                  final actions = ref.read(accountActionsProvider);
                  return actions.validateOpeningBalance(value);
                },
              ),
              const SizedBox(height: 16),
              // Icon selection
              DropdownButtonFormField<String>(
                value: _selectedIcon,
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  prefixIcon: Icon(Icons.emoji_emotions),
                  border: OutlineInputBorder(),
                ),
                items: _iconOptions.map((icon) {
                  final emoji = _getIconEmoji(icon);
                  return DropdownMenuItem(
                    value: icon,
                    child: Row(
                      children: [
                        Text(emoji),
                        const SizedBox(width: 8),
                        Text(icon.replaceFirst('_', ' ').toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedIcon = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Color selection
              DropdownButtonFormField<String>(
                value: _selectedColor,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  prefixIcon: Icon(Icons.palette),
                  border: OutlineInputBorder(),
                ),
                items: _colorOptions.map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(color),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedColor = value);
                  }
                },
              ),
              const Spacer(),
              // Current balance info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Current Balance: ${account.formattedBalance}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  String _getIconEmoji(String icon) {
    return AccountConstants.iconMapping[icon] ?? '💰';
  }
}
