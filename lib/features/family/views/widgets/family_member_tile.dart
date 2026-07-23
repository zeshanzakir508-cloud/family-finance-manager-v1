import 'package:flutter/material.dart';
import '../../enums/family_role.dart';
import '../../enums/member_status.dart';
import '../widgets/member_avatar.dart';
import '../widgets/role_chip.dart';
import '../widgets/owner_badge.dart';

/// Family member tile widget
class FamilyMemberTile extends StatelessWidget {
  final MemberModel member;
  final bool isCurrentUser;
  final bool canManage;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final VoidCallback? onChangeRole;
  final bool showStatus;

  const FamilyMemberTile({
    super.key,
    required this.member,
    this.isCurrentUser = false,
    this.canManage = false,
    this.onTap,
    this.onRemove,
    this.onChangeRole,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: MemberAvatar(
          name: member.name ?? '',
          size: 40,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.name ?? 'Unknown',
                style: TextStyle(
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isCurrentUser)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'You',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            RoleChip(role: member.role),
            if (showStatus && member.status != MemberStatus.active) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: member.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  member.status.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    color: member.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (member.role == FamilyRole.owner) ...[
              const SizedBox(width: 4),
              const OwnerBadge(),
            ],
          ],
        ),
        trailing: canManage
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'remove':
                      onRemove?.call();
                      break;
                    case 'change_role':
                      onChangeRole?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'change_role',
                    child: Text('Change Role'),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove Member'),
                  ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
