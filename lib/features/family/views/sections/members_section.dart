import 'package:flutter/material.dart';
import '../widgets/family_member_tile.dart';

/// Members section showing member list preview
class MembersSection extends StatelessWidget {
  final List<MemberModel> members;
  final int totalCount;
  final VoidCallback onViewAll;
  final Function(MemberModel) onMemberTap;

  const MembersSection({
    super.key,
    required this.members,
    required this.totalCount,
    required this.onViewAll,
    required this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members ($totalCount)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (totalCount > members.length)
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (members.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No members yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...members.map((member) {
            return FamilyMemberTile(
              member: member,
              isCurrentUser: false,
              canManage: false,
              onTap: () => onMemberTap(member),
              showStatus: true,
            );
          }),
      ],
    );
  }
}
