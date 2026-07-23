import 'package:flutter/material.dart';
import '../../enums/family_role.dart';
import '../widgets/role_chip.dart';

/// Roles section showing role distribution
class RolesSection extends StatelessWidget {
  final List<MemberModel> members;

  const RolesSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final roleCounts = _getRoleCounts();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...roleCounts.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  RoleChip(role: entry.key),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: members.isNotEmpty
                            ? entry.value / members.length
                            : 0,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          entry.key.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Map<FamilyRole, int> _getRoleCounts() {
    final counts = <FamilyRole, int>{};
    for (final role in FamilyRole.values) {
      counts[role] = 0;
    }
    for (final member in members) {
      counts[member.role] = (counts[member.role] ?? 0) + 1;
    }
    return counts;
  }
}
