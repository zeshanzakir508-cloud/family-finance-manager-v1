import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/family_role.dart';
import '../../providers/family_provider.dart';
import '../../providers/family_members_provider.dart';

/// Ownership transfer page
class OwnershipTransferPage extends ConsumerStatefulWidget {
  const OwnershipTransferPage({super.key});

  @override
  ConsumerState<OwnershipTransferPage> createState() =>
      _OwnershipTransferPageState();
}

class _OwnershipTransferPageState extends ConsumerState<OwnershipTransferPage> {
  String? _selectedMemberId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final members = ref.watch(familyMembersProvider);

    // Filter members who can be new owners (non-owners, active)
    final eligibleMembers = members
        .where((m) =>
            m.role != FamilyRole.owner &&
            m.status == MemberStatus.active)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Ownership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transfer ownership to another member',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will become a moderator after transferring ownership.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (eligibleMembers.isEmpty)
              const Center(
                child: Text('No eligible members to transfer ownership to'),
              )
            else ...[
              const Text(
                'Select new owner:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...eligibleMembers.map((member) {
                final isSelected = _selectedMemberId == member.id;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        member.name?.substring(0, 1).toUpperCase() ?? '?',
                      ),
                    ),
                    title: Text(member.name ?? 'Unknown'),
                    subtitle: Text(member.email ?? ''),
                    trailing: Radio<String>(
                      value: member.id,
                      groupValue: _selectedMemberId,
                      onChanged: (value) {
                        setState(() => _selectedMemberId = value);
                      },
                    ),
                    onTap: () {
                      setState(() => _selectedMemberId = member.id);
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading || _selectedMemberId == null
                      ? null
                      : _transferOwnership,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Transfer Ownership'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _transferOwnership() async {
    if (_selectedMemberId == null) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(familyActionsProvider);
      await actions.transferOwnership(_selectedMemberId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ownership transferred successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to transfer ownership: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
