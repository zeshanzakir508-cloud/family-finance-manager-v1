import 'package:flutter/material.dart';

/// Transaction summary section showing income, expenses, and net
class TransactionSummarySection extends StatelessWidget {
  final double income;
  final double expenses;
  final double netIncome;

  const TransactionSummarySection({
    super.key,
    required this.income,
    required this.expenses,
    required this.netIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: 'Income',
            value: '\$${income.toStringAsFixed(2)}',
            icon: Icons.arrow_upward,
            color: Colors.green,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade200,
          ),
          _SummaryItem(
            label: 'Expenses',
            value: '\$${expenses.toStringAsFixed(2)}',
            icon: Icons.arrow_downward,
            color: Colors.red,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade200,
          ),
          _SummaryItem(
            label: 'Net',
            value: '\$${netIncome.toStringAsFixed(2)}',
            icon: Icons.trending_up,
            color: netIncome >= 0 ? Colors.blue : Colors.red,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
