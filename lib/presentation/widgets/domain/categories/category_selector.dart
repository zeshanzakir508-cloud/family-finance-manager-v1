// lib/presentation/widgets/domain/categories/category_selector.dart

import 'package:flutter/material.dart';

import '../../buttons/app_button.dart';
import '../../buttons/enums/app_button_variant.dart';
import '../../buttons/enums/app_button_size.dart';
import '../../overlays/app_bottom_sheet.dart';
import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';

/// A widget for selecting a category.
///
/// This widget provides a standardized category selector for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// CategorySelector(
///   categories: categories,
///   selectedCategory: selectedCategory,
///   onCategorySelected: (category) => setState(() => selectedCategory = category),
/// )
/// ```
class CategorySelector extends StatelessWidget {
  /// The list of categories.
  final List<CategoryOption> categories;

  /// The currently selected category.
  final CategoryOption? selectedCategory;

  /// Callback when a category is selected.
  final ValueChanged<CategoryOption>? onCategorySelected;

  /// The label text.
  final String label;

  /// Whether the selector is disabled.
  final bool isDisabled;

  /// Creates a new [CategorySelector].
  const CategorySelector({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.label = 'Select Category',
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: selectedCategory?.label ?? label,
      onPressed: isDisabled ? null : () => _showCategoryPicker(context),
      variant: AppButtonVariant.outlined,
      size: AppButtonSize.medium,
      isDisabled: isDisabled || categories.isEmpty,
      leadingIcon: selectedCategory?.icon != null
          ? Icon(selectedCategory!.icon, size: 20)
          : null,
    );
  }

  void _showCategoryPicker(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: categories.map((category) {
          final isSelected = selectedCategory?.id == category.id;
          return AppTile(
            title: category.label,
            leading: category.icon != null
                ? Icon(category.icon, color: category.color)
                : null,
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              onCategorySelected?.call(category);
              Navigator.of(context).pop();
            },
            selected: isSelected,
            variant: TileVariant.filled,
          );
        }).toList(),
      ),
    );
  }
}

/// A category option for the selector.
class CategoryOption {
  /// The unique ID of the category.
  final String id;

  /// The display label.
  final String label;

  /// The optional icon.
  final IconData? icon;

  /// The optional color.
  final Color? color;

  /// Creates a new [CategoryOption].
  const CategoryOption({
    required this.id,
    required this.label,
    this.icon,
    this.color,
  });
}
