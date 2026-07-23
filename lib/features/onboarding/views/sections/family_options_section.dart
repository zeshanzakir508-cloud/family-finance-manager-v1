import 'package:flutter/material.dart';

/// Family options section with create/join options
class FamilyOptionsSection extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;

  const FamilyOptionsSection({
    super.key,
    required this.selectedOption,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FamilyOptionCard(
            title: 'Create Family',
            icon: Icons.create,
            description: 'Start a new family group',
            isSelected: selectedOption == 'create',
            onTap: () => onOptionChanged('create'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FamilyOptionCard(
            title: 'Join Family',
            icon: Icons.person_add,
            description: 'Join an existing family',
            isSelected: selectedOption == 'join',
            onTap: () => onOptionChanged('join'),
          ),
        ),
      ],
    );
  }
}

/// Family option card widget
class _FamilyOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _FamilyOptionCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
