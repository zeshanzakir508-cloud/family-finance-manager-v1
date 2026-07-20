// lib/presentation/widgets/domain/categories/category_chip.dart

import 'package:flutter/material.dart';

import '../../chips/app_chip.dart';
import '../../chips/enums/chip_variant.dart';
import '../../chips/enums/chip_size.dart';

/// A chip representing a category.
///
/// This widget provides a standardized category chip for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// CategoryChip(
///   label: 'Food',
///   icon: Icons.restaurant,
///   color: Colors.blue,
///   isSelected: isSelected,
/// )
/// ```
class CategoryChip extends StatelessWidget {
  /// The category label.
  final String label;

  /// The category icon.
  final IconData? icon;

  /// The category color.
  final Color? color;

  /// Whether the chip is selected.
  final bool isSelected;

  /// Callback when the chip is pressed.
  final VoidCallback? onPressed;

  /// Whether the chip is disabled.
  final bool isDisabled;

  /// Creates a new [CategoryChip].
  const CategoryChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.isSelected = false,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return AppChip(
      label: label,
      avatar: icon != null
          ? Icon(
              icon,
              color: isSelected ? null : effectiveColor,
              size: 16,
            )
          : null,
      selected: isSelected,
      onPressed: onPressed,
      isDisabled: isDisabled,
      variant: isSelected ? ChipVariant.filled : ChipVariant.outlined,
      size: ChipSize.medium,
    );
  }
}
