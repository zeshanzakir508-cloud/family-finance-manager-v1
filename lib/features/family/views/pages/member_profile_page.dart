import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';
import '../../providers/family_members_provider.dart';
import '../widgets/member_avatar.dart';
import '../widgets/role_chip.dart';
import '../widgets/owner_badge.dart';

/// Member profile page showing member details
class MemberProfilePage extends ConsumerWidget {
  final String memberId;

  const MemberProfilePage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = ref.watch(familyMemberByIdProvider(memberId));
    final state = ref.watch(familyStateProvider);
    final actions = ref.watch(familyActionsProvider);

    if (member == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Member Profile')),
        body: const Center(child: Text('Member not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
        actions: [
          if (state.canManageFamily)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'change_role':
                    _showChangeRoleDialog(context, member, actions);
                    break;
                  case 'suspend':
                    _showSuspendDialog(context, member, actions);
                    break;
                  case 'remove':
                    _showRemoveDialog(context, member, actions);
                    break;
                  case 'transfer':
                    _showTransferDialog(context, member, actions);
                    break;
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuEntry<String>>[];
                if (state.isOwner && member.role != FamilyRole.owner) {
                  items.add(const PopupMenuItem(
                    value: 'change_role',
                    child: Text('Change Role'),
                  ));
                  if (member.status == MemberStatus.active) {
                    items.add(const PopupMenuItem(
                      value: 'suspend',
                      child: Text('Suspend'),
                    ));
                  }
                  if (member.status == MemberStatus.suspended) {
                    items.add(const PopupMenuItem(
                      value: 'restore',
                      child: Text('Restore'),
                    ));
                  }
                  items.add(const PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove Member'),
                  ));
                  if (member.role != FamilyRole.owner) {
                    items.add(const PopupMenuItem(
                      value: 'transfer',
                      child: Text('Transfer Ownership'),
                    ));
                  }
                }
                return items;
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar and name
            Center(
              child: Column(
                children: [
                  MemberAvatar(
                    name: member.name ?? '',
                    size: 100,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    member.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.email ?? 'No email',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoleChip(role: member.role),
                      const SizedBox(width: 8),
                      if (member.role == FamilyRole.owner)
                        const OwnerBadge(),
                      if (member.status != MemberStatus.active)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: member.status.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            member.status.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: member.status.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Member details
            _DetailTile(
              icon: Icons.email,
              label: 'Email',
              value: member.email ?? 'Not provided',
            ),
            _DetailTile(
              icon: Icons.person,
              label: 'Joined',
              value: _formatDate(member.joinedAt),
            ),
            _DetailTile(
              icon: Icons.admin_panel_settings,
              label: 'Role',
              value: member.role.displayName,
            ),
            _DetailTile(
              icon: Icons.circle,
              label: 'Status',
              value: member.status.displayName,
              valueColor: member.status.color,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showChangeRoleDialog(BuildContext context, MemberModel member, FamilyActions actions) {
    // Similar to change role dialog in FamilyMembersPage
  }

  void _showSuspendDialog(BuildContext context, MemberModel member, FamilyActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Member'),
        content: Text('Are you sure you want to suspend ${member.name ?? member.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.suspendMember(member.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member suspended successfully')),
                  );
                }
              } catch (e) {
                // Handle error
              }
            },
            child: const Text('Suspend', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, MemberModel member, FamilyActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.name ?? member.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.removeMember(member.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member removed successfully')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                // Handle error
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog(BuildContext context, MemberModel member, FamilyActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Ownership'),
        content: Text('Are you sure you want to transfer ownership to ${member.name ?? member.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.transferOwnership(member.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ownership transferred successfully')),
                  );
                }
              } catch (e) {
                // Handle error
              }
            },
            child: const Text('Transfer', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
