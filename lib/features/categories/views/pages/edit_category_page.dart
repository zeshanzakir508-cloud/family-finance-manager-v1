import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';

/// Edit category page
class EditCategoryPage extends ConsumerStatefulWidget {
  final String categoryId;

  const EditCategoryPage({super.key, required this.categoryId});

  @override
  ConsumerState<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends ConsumerState<EditCategoryPage> {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategory();
    });
  }

  Future<void> _loadCategory() async {
    final actions = ref.read(categoryActionsProvider);
    await actions.loadCategory(widget.categoryId);
    
    final category = ref.read(selectedCategoryProvider);
    if (category != null) {
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _selectedIcon = category.icon;
      _selectedColor = category.color;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final actions = ref.read(categoryActionsProvider);
      await actions.updateCategory(
        categoryId: widget.categoryId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category: $e')),
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
    final category = ref.watch(selectedCategoryProvider);
    final isLoading = ref.watch(categoriesLoadingProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Category')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Category')),
        body: const Center(child: Text('Category not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateCategory,
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
                    if (category.isArchived)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Archived',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
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
