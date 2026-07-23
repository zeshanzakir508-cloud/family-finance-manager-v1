import 'package:flutter/material.dart';
import '../../enums/family_role.dart';
import '../widgets/owner_badge.dart';
import '../widgets/role_chip.dart';

/// Family card widget for displaying family in a list
class FamilyCard extends StatelessWidget {
  final FamilyModel family;
  final int memberCount;
  final bool isCurrentFamily;
  final bool isOwner;
  final VoidCallback? onTap;

  const FamilyCard({
    super.key,
    required this.family,
    required this.memberCount,
    this.isCurrentFamily = false,
    this.isOwner = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            family.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                family.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isCurrentFamily)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Icon(Icons.people, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              '$memberCount members',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(width: 12),
            if (isOwner)
              const OwnerBadge(),
          ],
        ),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }
}
