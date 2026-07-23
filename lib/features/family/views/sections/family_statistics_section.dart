import 'package:flutter/material.dart';
import '../../models/family_statistics_model.dart';
import '../widgets/family_statistics_card.dart';

/// Family statistics section showing key metrics
class FamilyStatisticsSection extends StatelessWidget {
  final FamilyStatisticsModel? statistics;
  final int memberCount;
  final int pendingInvites;

  const FamilyStatisticsSection({
    super.key,
    this.statistics,
    required this.memberCount,
    required this.pendingInvites,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FamilyStatisticsCard(
                title: 'Members',
                value: memberCount.toString(),
                icon: Icons.people,
                color: Colors.blue,
                subtitle: '${statistics?.activeMembers ?? 0} active',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FamilyStatisticsCard(
                title: 'Accounts',
                value: (statistics?.totalAccounts ?? 0).toString(),
                icon: Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FamilyStatisticsCard(
                title: 'Categories',
                value: (statistics?.totalCategories ?? 0).toString(),
                icon: Icons.category,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FamilyStatisticsCard(
                title: 'Pending',
                value: pendingInvites.toString(),
                icon: Icons.pending,
                color: Colors.purple,
                subtitle: 'invitations',
              ),
            ),
          ],
        ),
        if (statistics != null) ...[
          const SizedBox(height: 8),
          FamilyStatisticsCard(
            title: 'Transactions',
            value: (statistics!.totalTransactions).toString(),
            icon: Icons.receipt_long,
            color: Colors.teal,
            subtitle: '\$${statistics!.totalAmount.toStringAsFixed(2)}',
          ),
        ],
      ],
    );
  }
}
