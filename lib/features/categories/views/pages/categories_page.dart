import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';
import '../sections/categories_summary_section.dart';
import '../sections/categories_list_section.dart';

/// Categories page showing list of categories with summary
class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(categoryActionsProvider).setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryControllerProvider);
    final actions = ref.watch(categoryActionsProvider);
    final filteredCategories = ref.watch(filteredCategoriesProvider);
    final isLoading = ref.watch(categoriesLoadingProvider);
    final error = ref.watch(categoriesErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : () => actions.refresh(),
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search categories...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'archived', child: Text('Archived')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filter = value;
                      });
                      actions.setFilter(value);
                    }
                  },
                ),
              ],
            ),
          ),
          // Summary section
          CategoriesSummarySection(
            totalCount: filteredCategories.length,
            activeCount: ref.watch(activeCategoryCountProvider),
            archivedCount: ref.watch(archivedCategoryCountProvider),
          ),
          const SizedBox(height: 8),
          // Categories list
          Expanded(
            child: error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                        const SizedBox(height: 8),
                        Text(error),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => actions.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CategoriesListSection(
                        categories: filteredCategories,
                        onCategoryTap: (category) => _showCategoryOptions(category, actions),
                        onEdit: (category) => context.goToEditCategory(category.id),
                        onArchive: (category) => _showArchiveDialog(category, actions),
                        onDelete: (category) => _showDeleteDialog(category, actions),
                        onRestore: (category) => _restoreCategory(category, actions),
                        onMerge: (category) => _showMergeDialog(category, actions),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goToAddCategory(),
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }

  void _showCategoryOptions(CategoryModel category, CategoryActions actions) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                context.goToEditCategory(category.id);
              },
            ),
            if (!category.isArchived)
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                  _showArchiveDialog(category, actions);
                },
              ),
            if (category.isArchived)
              ListTile(
                leading: const Icon(Icons.unarchive),
                title: const Text('Restore'),
                onTap: () {
                  Navigator.pop(context);
                  _restoreCategory(category, actions);
                },
              ),
            ListTile(
              leading: const Icon(Icons.merge_type),
              title: const Text('Merge'),
              onTap: () {
                Navigator.pop(context);
                _showMergeDialog(category, actions);
              },
            ),
            if (!category.isArchived)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog(category, actions);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showArchiveDialog(CategoryModel category, CategoryActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Category'),
        content: Text('Are you sure you want to archive "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.archiveCategory(category.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category archived successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to archive: $e')),
                  );
                }
              }
            },
            child: const Text('Archive', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(CategoryModel category, CategoryActions actions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${category.name}"?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await actions.deleteCategory(category.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _restoreCategory(CategoryModel category, CategoryActions actions) async {
    try {
      await actions.restoreCategory(category.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category restored successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restore: $e')),
        );
      }
    }
  }

  void _showMergeDialog(CategoryModel sourceCategory, CategoryActions actions) {
    final activeCategories = ref.read(activeCategoriesProvider);
    final availableTargets = activeCategories
        .where((c) => c.id != sourceCategory.id)
        .toList();

    if (availableTargets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other categories available to merge into')),
      );
      return;
    }

    CategoryModel? selectedTarget;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Merge Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merge "${sourceCategory.name}" into another category.'),
              const SizedBox(height: 16),
              const Text(
                'Select target category:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...availableTargets.map((target) {
                return RadioListTile<CategoryModel>(
                  title: Row(
                    children: [
                      Text(target.iconEmoji),
                      const SizedBox(width: 8),
                      Text(target.name),
                    ],
                  ),
                  value: target,
                  groupValue: selectedTarget,
                  onChanged: (value) {
                    setState(() {
                      selectedTarget = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 8),
              const Text(
                'All transactions from the source category will be moved to the target category.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: selectedTarget == null
                  ? null
                  : () async {
                      Navigator.pop(context);
                      try {
                        await actions.mergeCategories(
                          sourceCategoryId: sourceCategory.id,
                          targetCategoryId: selectedTarget!.id,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Categories merged successfully')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to merge: $e')),
                          );
                        }
                      }
                    },
              child: const Text('Merge'),
            ),
          ],
        ),
      ),
    );
  }
}
