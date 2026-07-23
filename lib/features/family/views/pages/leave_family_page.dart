import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';

/// Leave family page
class LeaveFamilyPage extends ConsumerStatefulWidget {
  const LeaveFamilyPage({super.key});

  @override
  ConsumerState<LeaveFamilyPage> createState() => _LeaveFamilyPageState();
}

class _LeaveFamilyPageState extends ConsumerState<LeaveFamilyPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final family = state.currentFamily;

    if (family == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Leave Family')),
        body: const Center(child: Text('No family selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Family'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Leaving ${family.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure you want to leave this family?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You will lose access to all family data and transactions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (state.isOnlyOwner) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You are the only owner. Transfer ownership first or delete the family.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!state.isOnlyOwner) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _leaveFamily,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Leave Family'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _leaveFamily() async {
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(familyActionsProvider);
      await actions.leaveFamily();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have left the family.')),
        );
        Navigator.popUntil(context, (route) => route.settings.name == '/family');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to leave family: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
