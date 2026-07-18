// lib/domain/entities/category.dart

import 'package:equatable/equatable.dart';

import '../enums/category_type.dart';

/// Category entity representing a transaction category.
///
/// Categories are used to classify transactions as income or expense.
/// Categories can be hierarchical (parent-child relationship) and
/// can be shared within a family.
class Category extends Equatable {
  /// Unique identifier for the category.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the user who owns this category.
  final String userId;

  /// Name of the category.
  final String name;

  /// Type of category (income, expense, or transfer).
  final CategoryType type;

  /// Icon name or emoji for the category.
  final String? icon;

  /// Color hex code for the category.
  final String? color;

  /// Optional description of the category.
  final String? description;

  /// Whether this is a default category provided by the system.
  final bool isDefault;

  /// Whether the category is active.
  final bool isActive;

  /// ID of the family this category belongs to (if any).
  final String? familyId;

  /// ID of the parent category (for hierarchical categories).
  final String? parentId;

  /// Order of the category for display purposes.
  final int order;

  const Category({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.description,
    this.isDefault = false,
    this.isActive = true,
    this.familyId,
    this.parentId,
    this.order = 0,
  });

  /// Creates a copy of this category with the given fields replaced.
  Category copyWith({
    String? id,
    String? userId,
    String? name,
    CategoryType? type,
    String? icon,
    String? color,
    String? description,
    bool? isDefault,
    bool? isActive,
    String? familyId,
    String? parentId,
    int? order,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      familyId: familyId ?? this.familyId,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        icon,
        color,
        description,
        isDefault,
        isActive,
        familyId,
        parentId,
        order,
      ];
}
