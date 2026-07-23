import 'package:flutter/material.dart';
import '../widgets/account_card.dart';

/// Accounts list section showing list of accounts
class AccountsListSection extends StatelessWidget {
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountTap;
  final Function(AccountModel)? onEdit;
  final Function(AccountModel)? onArchive;
  final Function(AccountModel)? onDelete;
  final Function(AccountModel)? onRestore;

  const AccountsListSection({
    super.key,
    required this.accounts,
    required this.onAccountTap,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No accounts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first account to get started',
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
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AccountCard(
            account: account,
            onTap: () => onAccountTap(account),
            onEdit: onEdit != null ? () => onEdit!(account) : null,
            onArchive: onArchive != null && !account.isArchived
                ? () => onArchive!(account)
                : null,
            onDelete: onDelete != null && !account.isArchived
                ? () => onDelete!(account)
                : null,
            onRestore: onRestore != null && account.isArchived
                ? () => onRestore!(account)
                : null,
          ),
        );
      },
    );
  }
}
