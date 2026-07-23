import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';
import '../../validators/family_validator.dart';

/// Family settings page
class FamilySettingsPage extends ConsumerStatefulWidget {
  const FamilySettingsPage({super.key});

  @override
  ConsumerState<FamilySettingsPage> createState() => _FamilySettingsPageState();
}

class _FamilySettingsPageState extends ConsumerState<FamilySettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedCurrency = 'USD';
  bool _isLoading = false;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
  ];

  @override
  void initState() {
    super.initState();
    final family = ref.read(currentFamilyProvider);
    _nameController = TextEditingController(text: family?.name ?? '');
    _descriptionController = TextEditingController(text: family?.description ?? '');
    _selectedCurrency = family?.currency ?? 'USD';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(familyActionsProvider);
      await actions.updateFamily(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        currency: _selectedCurrency,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyStateProvider);
    final family = state.currentFamily;

    if (family == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Family Settings')),
        body: const Center(child: Text('No family selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Family Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Family Name',
                  prefixIcon: Icon(Icons.family_restroom),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final result = FamilyValidator.validateFamilyName(value);
                  return result.isValid ? null : result.message;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCurrency = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              // Danger zone
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
                          'Danger Zone',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These actions are permanent and cannot be undone.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.goToLeaveFamily(),
                            icon: const Icon(Icons.exit_to_app),
                            label: const Text('Leave Family'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.goToTransferOwnership(),
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('Transfer Ownership'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: state.isOwner
                            ? () => context.goToDeleteFamily()
                            : null,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete Family'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
