import 'package:flutter/material.dart';
import '../widgets/member_avatar.dart';
import '../widgets/owner_badge.dart';

/// Owner section showing family owner details
class OwnerSection extends StatelessWidget {
  final MemberModel owner;

  const OwnerSection({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          MemberAvatar(
            name: owner.name ?? '',
            size: 48,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.name ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Family Owner',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const OwnerBadge(),
        ],
      ),
    );
  }
}
