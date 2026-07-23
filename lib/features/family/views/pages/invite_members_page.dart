import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/family_role.dart';
import '../../providers/family_provider.dart';
import '../../providers/family_invitation_provider.dart';
import '../widgets/invite_card.dart';

/// Invite members page
class InviteMembersPage extends ConsumerStatefulWidget {
  final String? familyId;

  const InviteMembersPage({super.key, this.familyId});

  @override
  ConsumerState<InviteMembersPage> createState() => _InviteMembersPageState();
}

class _InviteMembersPageState extends ConsumerState<InviteMembersPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  FamilyRole _selectedRole = FamilyRole.member;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (_emailController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(familyActionsProvider);
      await actions.inviteMember(
        _emailController.text.trim(),
        name: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        role: _selectedRole,
      );

      _emailController.clear();
      _nameController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invitation sent successfully!')),
        );
        // Refresh invitations
        ref.read(familyNotifierProvider.notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send invitation: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final invitations = ref.watch(familyInvitationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Members'),
      ),
      body: Column(
        children: [
          // Invite form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send an invitation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Invite members to join your family.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name (Optional)',
                    hintText: 'Enter member name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<FamilyRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.admin_panel_settings),
                    border: OutlineInputBorder(),
                  ),
                  items: FamilyRole.values.where((r) => r != FamilyRole.owner).map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendInvite,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Send Invitation'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Invitations list
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : invitations.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No invitations sent yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: invitations.length,
                        itemBuilder: (context, index) {
                          final invite = invitations[index];
                          return InviteCard(
                            invitation: invite,
                            onCancel: () async {
                              try {
                                final repo = ref.read(familyRepositoryProvider);
                                await repo.cancelInvitation(invite.id);
                                ref.read(familyNotifierProvider.notifier).refresh();
                              } catch (e) {
                                // Handle error
                              }
                            },
                            onResend: () async {
                              try {
                                final repo = ref.read(familyRepositoryProvider);
                                await repo.resendInvitation(invite.id);
                                ref.read(familyNotifierProvider.notifier).refresh();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invitation resent successfully'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Handle error
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
