import 'package:flutter/material.dart';
import '../../models/onboarding_page_model.dart';

/// Category preview section showing category grid
class CategoryPreviewSection extends StatelessWidget {
  final List<CategoryItem> categories;
  final Function(String) onCategoryTapped;

  const CategoryPreviewSection({
    super.key,
    required this.categories,
    required this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onTap: () => onCategoryTapped(category.id),
        );
      },
    );
  }
}

/// Category tile widget
class _CategoryTile extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('FF${category.color.replaceFirst('#', '')}', radix: 16));
    final isSelected = category.selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                color: color,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
