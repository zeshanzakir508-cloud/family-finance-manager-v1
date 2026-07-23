import 'package:flutter/material.dart';

/// Category selector widget for picking a category
class CategorySelector extends StatelessWidget {
  final String label;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final Function(CategoryModel?) onChanged;
  final String? excludeId;
  final String? hint;

  const CategorySelector({
    super.key,
    required this.label,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    this.excludeId,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final availableCategories = excludeId != null
        ? categories.where((c) => c.id != excludeId).toList()
        : categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CategoryModel>(
              value: selectedCategory,
              hint: Text(hint ?? 'Select category'),
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: availableCategories.map((category) {
                final color = Color(category.colorValue);
                final iconEmoji = category.iconEmoji;
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            iconEmoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (category.description != null)
                              Text(
                                category.description!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (category.isArchived)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Archived',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
