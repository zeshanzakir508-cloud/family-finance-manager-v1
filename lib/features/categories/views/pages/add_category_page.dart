import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';

/// Add category page
class AddCategoryPage extends ConsumerStatefulWidget {
  const AddCategoryPage({super.key});

  @override
  ConsumerState<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = 'category';
  String _selectedColor = '#45B7D1';
  bool _isLoading = false;

  final List<String> _iconOptions = [
    'category', 'shopping', 'food', 'transport', 'house', 'health',
    'education', 'entertainment', 'savings', 'income', 'bill', 'gift',
  ];

  final List<String> _colorOptions = [
    '#45B7D1', '#FF6B6B', '#4ECDC4', '#96CEB4', '#FF9F43', '#A29BFE',
    '#FD79A8', '#00CEC9', '#FDCB6E', '#6C5CE7', '#00B894', '#E17055',
  ];

  final Map<String, String> _iconMapping = {
    'category': '📁',
    'shopping': '🛍️',
    'food': '🍔',
    'transport': '🚗',
    'house': '🏠',
    'health': '💊',
    'education': '📚',
    'entertainment': '🎮',
    'savings': '🏦',
    'income': '💰',
    'bill': '📄',
    'gift': '🎁',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(categoryActionsProvider);
      await actions.createCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create category: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveCategory,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Category name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final actions = ref.read(categoryActionsProvider);
                  return actions.validateName(value);
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add a brief description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Icon selection
              DropdownButtonFormField<String>(
                value: _selectedIcon,
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  prefixIcon: Icon(Icons.emoji_emotions),
                  border: OutlineInputBorder(),
                ),
                items: _iconOptions.map((icon) {
                  final emoji = _iconMapping[icon] ?? '📁';
                  return DropdownMenuItem(
                    value: icon,
                    child: Row(
                      children: [
                        Text(emoji),
                        const SizedBox(width: 8),
                        Text(icon.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedIcon = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Color selection
              DropdownButtonFormField<String>(
                value: _selectedColor,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  prefixIcon: Icon(Icons.palette),
                  border: OutlineInputBorder(),
                ),
                items: _colorOptions.map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(color),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedColor = value);
                  }
                },
              ),
              const Spacer(),
              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(int.parse('FF${_selectedColor.replaceFirst('#', '')}', radix: 16)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _iconMapping[_selectedIcon] ?? '📁',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.isEmpty
                                ? 'Category Name'
                                : _nameController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _descriptionController.text.isEmpty
                                ? 'No description'
                                : _descriptionController.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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
