import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';

/// Delete family page
class DeleteFamilyPage extends ConsumerStatefulWidget {
  const DeleteFamilyPage({super.key});

  @override
  ConsumerState<DeleteFamilyPage> createState() => _DeleteFamilyPageState();
}

class _DeleteFamilyPageState extends ConsumerState<DeleteFamilyPage> {
  bool _isLoading = false;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final family = state.currentFamily;

    if (family == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Delete Family')),
        body: const Center(child: Text('No family selected')),
      );
    }

    if (!state.isOwner) {
      return Scaffold(
        appBar: AppBar(title: const Text('Delete Family')),
        body: const Center(
          child: Text('Only the family owner can delete the family.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Family'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Delete ${family.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This action is permanent and cannot be undone.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All members, transactions, and data will be permanently deleted.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Members:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  ...state.members.map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text('• ${member.name ?? member.email}'),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              title: const Text('I understand that this action is permanent'),
              value: _confirmed,
              onChanged: (value) {
                setState(() => _confirmed = value ?? false);
              },
              activeColor: Colors.red,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || !_confirmed ? null : _deleteFamily,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Delete Family'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteFamily() async {
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(familyActionsProvider);
      await actions.deleteFamily();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Family deleted successfully.')),
        );
        Navigator.popUntil(context, (route) => route.settings.name == '/family');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete family: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
