import 'package:flutter/material.dart';

/// Category card widget for displaying category information
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onMerge;
  final int? transactionCount;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    this.onRestore,
    this.onMerge,
    this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    final iconEmoji = category.iconEmoji;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (category.description != null) ...[
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (transactionCount != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '$transactionCount transactions',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Archived badge
              if (category.isArchived) ...[
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
                const SizedBox(width: 8),
              ],
              // Actions menu
              if (onEdit != null || onArchive != null || onDelete != null || onRestore != null || onMerge != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'archive':
                        onArchive?.call();
                        break;
                      case 'restore':
                        onRestore?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                      case 'merge':
                        onMerge?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    final items = <PopupMenuEntry<String>>[];
                    if (onEdit != null && !category.isArchived) {
                      items.add(const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ));
                    }
                    if (onMerge != null && !category.isArchived) {
                      items.add(const PopupMenuItem(
                        value: 'merge',
                        child: Text('Merge'),
                      ));
                    }
                    if (onArchive != null && !category.isArchived) {
                      items.add(const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive'),
                      ));
                    }
                    if (onRestore != null && category.isArchived) {
                      items.add(const PopupMenuItem(
                        value: 'restore',
                        child: Text('Restore'),
                      ));
                    }
                    if (onDelete != null && !category.isArchived) {
                      items.add(const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ));
                    }
                    return items;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
