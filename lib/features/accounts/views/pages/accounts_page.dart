import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/account_provider.dart';
import '../sections/accounts_summary_section.dart';
import '../sections/accounts_list_section.dart';
import '../widgets/account_selector.dart';

/// Accounts page showing list of accounts with summary
class AccountsPage extends ConsumerStatefulWidget {
  const AccountsPage({super.key});

  @override
  ConsumerState<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends ConsumerState<AccountsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'all';

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
    ref.read(accountActionsProvider).setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountControllerProvider);
    final actions = ref.watch(accountActionsProvider);
    final filteredAccounts = ref.watch(filteredAccountsProvider);
    final totalBalance = ref.watch(totalBalanceProvider);
    final isLoading = ref.watch(accountsLoadingProvider);
    final error = ref.watch(accountsErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : () => actions.refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search accounts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'archived', child: Text('Archived')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filter = value;
                      });
                      actions.setFilter(value);
                    }
                  },
                ),
              ],
            ),
          ),
          // Summary section
          AccountsSummarySection(
            totalBalance: totalBalance,
            accountCount: filteredAccounts.length,
          ),
          const SizedBox(height: 8),
          // Accounts list
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
                    : AccountsListSection(
                        accounts: filteredAccounts,
                        onAccountTap: (account) => context.goToAccountDetails(account.id),
                        onEdit: (account) => context.goToEditAccount(account.id),
                        onArchive: (account) => _showArchiveDialog(account, actions),
                        onDelete: (account) => _showDeleteDialog(account, actions),
                        onRestore: (account) => _restoreAccount(account, actions),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goToAddAccount(),
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
      ),
    );
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
              try {
                await actions.archiveAccount(account.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account archived successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to archive: $e')),
                  );
                }
              }
            },
            child: const Text('Archive', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
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
}
