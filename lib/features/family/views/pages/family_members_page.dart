import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';
import '../widgets/family_member_tile.dart';

/// Family members page showing all members
class FamilyMembersPage extends ConsumerStatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  ConsumerState<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends ConsumerState<FamilyMembersPage> {
  String _searchQuery = '';
  String _filterRole = 'all';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final actions = ref.watch(familyActionsProvider);

    // Filter members
    var members = state.members;
    if (_searchQuery.isNotEmpty) {
      members = members.where((m) {
        final name = m.name?.toLowerCase() ?? '';
        final email = m.email?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }
    if (_filterRole != 'all') {
      members = members.where((m) => m.role.name == _filterRole).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
        actions: [
          if (state.canInviteMembers)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => context.goToInviteMembers(),
              tooltip: 'Invite Members',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search members...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterRole,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All')),
                    ...FamilyRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role.name,
                        child: Text(role.displayName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _filterRole = value);
                    }
                  },
                ),
              ],
            ),
          ),
          // Member list
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : members.isEmpty
                    ? const Center(child: Text('No members found'))
                    : ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          final isCurrentUser = false; // TODO: Check current user
                          return FamilyMemberTile(
                            member: member,
                            isCurrentUser: isCurrentUser,
                            canManage: state.canManageFamily && !isCurrentUser,
                            onTap: () => context.goToMemberProfile(member.id),
                            onRemove: () => _showRemoveMemberDialog(context, member, actions),
                            onChangeRole: () => _showChangeRoleDialog(context, member, actions),
                          );
                        },
                      ),
          ),
          // Member count
          if (!state.isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Center(
                child: Text(
                  '${members.length} members · ${state.activeMembers.length} active',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showRemoveMemberDialog(BuildContext context, MemberModel member, FamilyActions actions) {
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
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove member: $e')),
                  );
                }
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, MemberModel member, FamilyActions actions) {
    FamilyRole selectedRole = member.role;
    final roles = FamilyRole.values.where((r) => r != FamilyRole.owner).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles.map((role) {
            return RadioListTile<FamilyRole>(
              title: Text(role.displayName),
              subtitle: Text(role.description),
              value: role,
              groupValue: selectedRole,
              onChanged: (value) {
                if (value != null) {
                  selectedRole = value;
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (selectedRole != member.role) {
                try {
                  await actions.changeRole(member.id, selectedRole);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Role changed successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to change role: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
