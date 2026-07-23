import 'package:flutter/material.dart';

/// Categories summary section showing category counts
class CategoriesSummarySection extends StatelessWidget {
  final int totalCount;
  final int activeCount;
  final int archivedCount;

  const CategoriesSummarySection({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.archivedCount,
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
            label: 'Total',
            value: totalCount.toString(),
            icon: Icons.category,
            color: Colors.blue,
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.shade200,
          ),
          _SummaryItem(
            label: 'Active',
            value: activeCount.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.shade200,
          ),
          _SummaryItem(
            label: 'Archived',
            value: archivedCount.toString(),
            icon: Icons.archive,
            color: Colors.orange,
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
                fontSize: 16,
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
