import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/onboarding_provider.dart';

/// Account Setup page
class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({super.key});

  @override
  ConsumerState<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  String _selectedAccountType = 'Checking';
  bool _isAccountSetUp = false;

  final List<String> _accountTypes = [
    'Checking',
    'Savings',
    'Credit Card',
    'Cash',
    'Investment',
  ];

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _loadAccountData() {
    final metadata = ref.read(onboardingMetadataProvider);
    final accountName = metadata?['accountName'] as String?;
    final accountBalance = metadata?['accountBalance'] as double?;
    final accountType = metadata?['accountType'] as String?;
    
    if (accountName != null && accountName.isNotEmpty) {
      _accountNameController.text = accountName;
      _isAccountSetUp = true;
    }
    if (accountBalance != null) {
      _balanceController.text = accountBalance.toString();
    }
    if (accountType != null) {
      _selectedAccountType = accountType;
    }
  }

  void _saveAccountData() {
    final name = _accountNameController.text.trim();
    final balance = double.tryParse(_balanceController.text.trim()) ?? 0.0;
    
    if (name.isNotEmpty) {
      ref.read(onboardingNotifierProvider.notifier).saveMetadata({
        'accountName': name,
        'accountBalance': balance,
        'accountType': _selectedAccountType,
        'accountSetup': true,
      });
      
      // Mark step as complete
      ref.read(onboardingNotifierProvider.notifier).completeStep(OnboardingStep.accounts);
      
      setState(() {
        _isAccountSetUp = true;
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Account Setup',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your main account to start tracking finances.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Account name
          TextField(
            controller: _accountNameController,
            decoration: InputDecoration(
              labelText: 'Account Name',
              hintText: 'e.g., Main Account',
              prefixIcon: const Icon(Icons.account_balance_wallet),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabled: !_isAccountSetUp,
            ),
          ),
          const SizedBox(height: 16),
          // Account type dropdown
          DropdownButtonFormField<String>(
            value: _selectedAccountType,
            decoration: InputDecoration(
              labelText: 'Account Type',
              prefixIcon: const Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabled: !_isAccountSetUp,
            ),
            items: _accountTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAccountType = value ?? 'Checking';
              });
            },
          ),
          const SizedBox(height: 16),
          // Opening balance
          TextField(
            controller: _balanceController,
            decoration: InputDecoration(
              labelText: 'Opening Balance',
              hintText: '0.00',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabled: !_isAccountSetUp,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // Action buttons
          if (!_isAccountSetUp) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _accountNameController.text.trim().isNotEmpty
                        ? _saveAccountData
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Account "${_accountNameController.text}" created!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Opening Balance: \$${_balanceController.text.trim() ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
