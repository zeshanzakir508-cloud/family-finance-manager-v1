import 'package:flutter/material.dart';
import '../widgets/category_card.dart';

/// Categories list section showing list of categories
class CategoriesListSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  final Function(CategoryModel)? onEdit;
  final Function(CategoryModel)? onArchive;
  final Function(CategoryModel)? onDelete;
  final Function(CategoryModel)? onRestore;
  final Function(CategoryModel)? onMerge;

  const CategoriesListSection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    this.onRestore,
    this.onMerge,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No categories found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first category to organize transactions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CategoryCard(
            category: category,
            onTap: () => onCategoryTap(category),
            onEdit: onEdit != null ? () => onEdit!(category) : null,
            onArchive: onArchive != null && !category.isArchived
                ? () => onArchive!(category)
                : null,
            onDelete: onDelete != null && !category.isArchived
                ? () => onDelete!(category)
                : null,
            onRestore: onRestore != null && category.isArchived
                ? () => onRestore!(category)
                : null,
            onMerge: onMerge != null && !category.isArchived
                ? () => onMerge!(category)
                : null,
          ),
        );
      },
    );
  }
}
