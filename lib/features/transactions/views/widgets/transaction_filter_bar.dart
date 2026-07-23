import 'package:flutter/material.dart';
import '../../enums/transaction_type.dart';

/// Transaction filter bar widget
class TransactionFilterBar extends StatelessWidget {
  final TransactionType? currentType;
  final Function(TransactionType?) onTypeFilter;
  final VoidCallback onClearFilters;

  const TransactionFilterBar({
    super.key,
    this.currentType,
    required this.onTypeFilter,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 44,
      child: Row(
        children: [
          const Text(
            'Filter:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'All',
            isSelected: currentType == null,
            onTap: () => onTypeFilter(null),
          ),
          const SizedBox(width: 4),
          _FilterChip(
            label: 'Income',
            isSelected: currentType == TransactionType.income,
            onTap: () => onTypeFilter(TransactionType.income),
            color: Colors.green,
          ),
          const SizedBox(width: 4),
          _FilterChip(
            label: 'Expense',
            isSelected: currentType == TransactionType.expense,
            onTap: () => onTypeFilter(TransactionType.expense),
            color: Colors.red,
          ),
          const SizedBox(width: 4),
          _FilterChip(
            label: 'Transfer',
            isSelected: currentType == TransactionType.transfer,
            onTap: () => onTypeFilter(TransactionType.transfer),
            color: Colors.blue,
          ),
          const Spacer(),
          if (currentType != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: onClearFilters,
              tooltip: 'Clear filters',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? Colors.blue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? selectedColor
                : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
