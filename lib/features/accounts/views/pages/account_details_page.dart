import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/account_provider.dart';
import '../widgets/account_card.dart';

/// Account details page showing account information and transactions
class AccountDetailsPage extends ConsumerStatefulWidget {
  final String accountId;

  const AccountDetailsPage({super.key, required this.accountId});

  @override
  ConsumerState<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends ConsumerState<AccountDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountActionsProvider).loadAccount(widget.accountId);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(selectedAccountProvider);
    final isLoading = ref.watch(accountsLoadingProvider);
    final error = ref.watch(accountsErrorProvider);
    final actions = ref.watch(accountActionsProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account Details')),
        body: Center(
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
        ),
      );
    }

    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account Details')),
        body: const Center(child: Text('Account not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          if (!account.isArchived) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.goToEditAccount(account.id),
            ),
            IconButton(
              icon: const Icon(Icons.archive),
              onPressed: () => _showArchiveDialog(account, actions),
            ),
          ],
          if (account.isArchived)
            IconButton(
              icon: const Icon(Icons.unarchive),
              onPressed: () => _restoreAccount(account, actions),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'transfer':
                  context.goToTransfer(fromAccountId: account.id);
                  break;
                case 'delete':
                  _showDeleteDialog(account, actions);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'transfer',
                child: Text('Transfer'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Account card
            AccountCard(
              account: account,
              showFullDetails: true,
            ),
            const SizedBox(height: 24),
            // Account details
            _DetailTile(
              icon: Icons.description,
              label: 'Description',
              value: account.description ?? 'No description',
            ),
            const Divider(),
            _DetailTile(
              icon: Icons.attach_money,
              label: 'Opening Balance',
              value: account.formattedOpeningBalance,
            ),
            const Divider(),
            _DetailTile(
              icon: Icons.calendar_today,
              label: 'Created',
              value: _formatDate(account.createdAt),
            ),
            const Divider(),
            _DetailTile(
              icon: Icons.update,
              label: 'Last Updated',
              value: _formatDate(account.updatedAt),
            ),
            if (account.lastUsedAt != null) ...[
              const Divider(),
              _DetailTile(
                icon: Icons.history,
                label: 'Last Used',
                value: _formatDate(account.lastUsedAt!),
              ),
            ],
            const Divider(),
            _DetailTile(
              icon: Icons.family_restroom,
              label: 'Type',
              value: account.isFamilyAccount ? 'Family Account' : 'Personal Account',
            ),
            if (account.isArchived) ...[
              const Divider(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.archive, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'This account is archived',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Transfer button
            if (!account.isArchived)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.goToTransfer(fromAccountId: account.id),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Transfer Money'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showArchiveDialog(AccountModel account, AccountActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Account'),
        content: Text(
          account.hasBalance
              ? 'This account has a balance of ${account.formattedBalance}. Are you sure you want to archive it?'
              : 'Are you sure you want to archive "${account.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await actions.archiveAccount(account.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account archived successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Archive', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _restoreAccount(AccountModel account, AccountActions actions) async {
    try {
      await actions.restoreAccount(account.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account restored successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restore: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(AccountModel account, AccountActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          account.hasBalance
              ? 'This account has a balance of ${account.formattedBalance}. Are you sure you want to delete it?'
              : 'Are you sure you want to delete "${account.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.deleteAccount(account.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully')),
                  );
                  Navigator.pop(context);
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
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
