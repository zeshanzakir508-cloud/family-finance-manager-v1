import 'package:flutter/material.dart';
import '../../constants/account_constants.dart';

/// Account selector widget for picking an account
class AccountSelector extends StatelessWidget {
  final String label;
  final List<AccountModel> accounts;
  final AccountModel? selectedAccount;
  final Function(AccountModel?) onChanged;
  final String? excludeId;
  final String? hint;

  const AccountSelector({
    super.key,
    required this.label,
    required this.accounts,
    required this.selectedAccount,
    required this.onChanged,
    this.excludeId,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final availableAccounts = excludeId != null
        ? accounts.where((a) => a.id != excludeId).toList()
        : accounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AccountModel>(
              value: selectedAccount,
              hint: Text(hint ?? 'Select account'),
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: availableAccounts.map((account) {
                final color = Color(account.colorValue);
                final iconEmoji = account.iconEmoji;
                return DropdownMenuItem(
                  value: account,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            iconEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              account.formattedBalance,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (account.isArchived)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Archived',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
