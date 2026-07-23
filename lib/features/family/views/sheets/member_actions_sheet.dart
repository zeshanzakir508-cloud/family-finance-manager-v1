import 'package:flutter/material.dart';
import '../../enums/family_role.dart';
import '../../enums/member_status.dart';

/// Bottom sheet for member actions
class MemberActionsSheet extends StatelessWidget {
  final MemberModel member;
  final bool isOwner;
  final bool isCurrentUser;
  final VoidCallback? onViewProfile;
  final VoidCallback? onChangeRole;
  final VoidCallback? onSuspend;
  final VoidCallback? onRestore;
  final VoidCallback? onRemove;
  final VoidCallback? onTransferOwnership;

  const MemberActionsSheet({
    super.key,
    required this.member,
    required this.isOwner,
    required this.isCurrentUser,
    this.onViewProfile,
    this.onChangeRole,
    this.onSuspend,
    this.onRestore,
    this.onRemove,
    this.onTransferOwnership,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Member info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  member.name?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: member.role.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  member.role.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: member.role.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          // Actions
          if (onViewProfile != null)
            _ActionTile(
              icon: Icons.person,
              title: 'View Profile',
              onTap: () {
                Navigator.pop(context);
                onViewProfile!.call();
              },
            ),
          if (isOwner && !isCurrentUser && member.role != FamilyRole.owner) ...[
            if (onChangeRole != null)
              _ActionTile(
                icon: Icons.admin_panel_settings,
                title: 'Change Role',
                onTap: () {
                  Navigator.pop(context);
                  onChangeRole!.call();
                },
              ),
            if (member.status == MemberStatus.active && onSuspend != null)
              _ActionTile(
                icon: Icons.pause_circle,
                title: 'Suspend Member',
                onTap: () {
                  Navigator.pop(context);
                  onSuspend!.call();
                },
                iconColor: Colors.orange,
                textColor: Colors.orange,
              ),
            if (member.status == MemberStatus.suspended && onRestore != null)
              _ActionTile(
                icon: Icons.restore,
                title: 'Restore Member',
                onTap: () {
                  Navigator.pop(context);
                  onRestore!.call();
                },
                iconColor: Colors.green,
                textColor: Colors.green,
              ),
            if (onRemove != null && member.role != FamilyRole.owner)
              _ActionTile(
                icon: Icons.person_remove,
                title: 'Remove Member',
                onTap: () {
                  Navigator.pop(context);
                  onRemove!.call();
                },
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            if (onTransferOwnership != null && member.role != FamilyRole.owner)
              _ActionTile(
                icon: Icons.swap_horiz,
                title: 'Transfer Ownership',
                onTap: () {
                  Navigator.pop(context);
                  onTransferOwnership!.call();
                },
                iconColor: Colors.blue,
                textColor: Colors.blue,
              ),
          ],
          const SizedBox(height: 8),
          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Show the member actions sheet
  static Future<void> show(
    BuildContext context, {
    required MemberModel member,
    required bool isOwner,
    required bool isCurrentUser,
    VoidCallback? onViewProfile,
    VoidCallback? onChangeRole,
    VoidCallback? onSuspend,
    VoidCallback? onRestore,
    VoidCallback? onRemove,
    VoidCallback? onTransferOwnership,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MemberActionsSheet(
        member: member,
        isOwner: isOwner,
        isCurrentUser: isCurrentUser,
        onViewProfile: onViewProfile,
        onChangeRole: onChangeRole,
        onSuspend: onSuspend,
        onRestore: onRestore,
        onRemove: onRemove,
        onTransferOwnership: onTransferOwnership,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.blue,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
