import 'package:flutter/material.dart';
import '../../enums/family_role.dart';
import '../widgets/owner_badge.dart';
import '../widgets/role_chip.dart';

/// Family header section showing family name and basic info
class FamilyHeaderSection extends StatelessWidget {
  final FamilyModel family;
  final int memberCount;
  final bool isOwner;
  final bool isModerator;

  const FamilyHeaderSection({
    super.key,
    required this.family,
    required this.memberCount,
    required this.isOwner,
    required this.isModerator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      family.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (family.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        family.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isOwner)
                const OwnerBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.people,
                label: '$memberCount members',
              ),
              const SizedBox(width: 8),
              if (family.currency != null)
                _InfoChip(
                  icon: Icons.attach_money,
                  label: family.currency!,
                ),
              const SizedBox(width: 8),
              if (isModerator && !isOwner)
                RoleChip(role: FamilyRole.moderator),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
