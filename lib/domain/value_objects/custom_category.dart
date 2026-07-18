// lib/domain/value_objects/custom_category.dart

import 'package:equatable/equatable.dart';

import '../enums/category_type.dart';
import '../enums/category_icon.dart';
import '../enums/category_color.dart';

/// Value object representing a custom category created by the user.
class CustomCategory extends Equatable {
  /// Name of the category.
  final String name;

  /// Type of category (income or expense).
  final CategoryType type;

  /// Icon for the category.
  final CategoryIcon icon;

  /// Color for the category.
  final CategoryColor color;

  const CustomCategory({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  }) : assert(name.isNotEmpty, 'Category name cannot be empty');

  /// Creates a copy of this custom category with the given fields replaced.
  CustomCategory copyWith({
    String? name,
    CategoryType? type,
    CategoryIcon? icon,
    CategoryColor? color,
  }) {
    return CustomCategory(
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        name,
        type,
        icon,
        color,
      ];
}
