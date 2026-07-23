import 'package:flutter/material.dart';
import '../../constants/account_constants.dart';

/// Account card widget for displaying account information
class AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final bool showFullDetails;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    this.onRestore,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(account.colorValue);
    final iconEmoji = account.iconEmoji;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        iconEmoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and balance
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          account.formattedBalance,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: account.hasPositiveBalance
                                ? Colors.green
                                : account.hasNegativeBalance
                                    ? Colors.red
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  if (onEdit != null || onArchive != null || onDelete != null || onRestore != null)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'archive':
                            onArchive?.call();
                            break;
                          case 'restore':
                            onRestore?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        final items = <PopupMenuEntry<String>>[];
                        if (onEdit != null && !account.isArchived) {
                          items.add(const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ));
                        }
                        if (onArchive != null && !account.isArchived) {
                          items.add(const PopupMenuItem(
                            value: 'archive',
                            child: Text('Archive'),
                          ));
                        }
                        if (onRestore != null && account.isArchived) {
                          items.add(const PopupMenuItem(
                            value: 'restore',
                            child: Text('Restore'),
                          ));
                        }
                        if (onDelete != null && !account.isArchived) {
                          items.add(const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ));
                        }
                        return items;
                      },
                    ),
                  // Archived badge
                  if (account.isArchived) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Archived',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (showFullDetails) ...[
                const SizedBox(height: 12),
                if (account.description != null) ...[
                  Text(
                    account.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    _DetailChip(
                      label: 'Opening: ${account.formattedOpeningBalance}',
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(width: 8),
                    _DetailChip(
                      label: account.isFamilyAccount ? 'Family' : 'Personal',
                      icon: account.isFamilyAccount
                          ? Icons.family_restroom
                          : Icons.person,
                    ),
                    if (account.lastUsedAt != null) ...[
                      const SizedBox(width: 8),
                      _DetailChip(
                        label: _formatDate(account.lastUsedAt!),
                        icon: Icons.history,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DetailChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
