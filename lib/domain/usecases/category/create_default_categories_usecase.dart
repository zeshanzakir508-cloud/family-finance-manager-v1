// lib/domain/usecases/category/create_default_categories_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../enums/category_type.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [CreateDefaultCategoriesUseCase].
class CreateDefaultCategoriesParams extends Equatable {
  final String userId;
  final List<Category> defaultCategories;

  const CreateDefaultCategoriesParams({
    required this.userId,
    required this.defaultCategories,
  });

  @override
  List<Object?> get props => [userId, defaultCategories];
}

/// Result containing the created default categories.
class CreateDefaultCategoriesResult {
  final List<Category> categories;

  const CreateDefaultCategoriesResult({
    required this.categories,
  });
}

/// Use case for creating default categories for a new user.
///
/// This use case handles creating a set of default categories (income and expense)
/// when a new user registers. It validates the input and ensures the user
/// doesn't already have categories before delegating to the repository.
class CreateDefaultCategoriesUseCase {
  final CategoryRepository _repository;

  const CreateDefaultCategoriesUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the create default categories use case.
  ///
  /// [params] contains the user ID and the list of default categories to create.
  /// Returns a [CreateDefaultCategoriesResult] containing the created categories.
  /// Throws [CategoryException] if validation fails or creation fails.
  Future<CreateDefaultCategoriesResult> call(
    CreateDefaultCategoriesParams params,
  ) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const CategoryDataException('User ID cannot be empty.');
    }

    // Business rule: default categories list must not be empty
    if (params.defaultCategories.isEmpty) {
      throw const CategoryDataException(
        'Default categories list cannot be empty.',
      );
    }

    // Business rule: validate each default category
    for (final category in params.defaultCategories) {
      // Business rule: category name must not be empty
      if (category.name.trim().isEmpty) {
        throw const CategoryDataException('Category name cannot be empty.');
      }

      // Business rule: category name must be at least 2 characters
      if (category.name.trim().length < 2) {
        throw const CategoryDataException(
          'Category name must be at least 2 characters.',
        );
      }

      // Business rule: category name must not exceed 50 characters
      if (category.name.trim().length > 50) {
        throw const CategoryDataException(
          'Category name must not exceed 50 characters.',
        );
      }

      // Business rule: category must have an icon
      if (category.icon == null || category.icon!.trim().isEmpty) {
        throw CategoryDataException(
          'Category "${category.name}" must have an icon.',
        );
      }

      // Business rule: category must have a color
      if (category.color == null || category.color!.trim().isEmpty) {
        throw CategoryDataException(
          'Category "${category.name}" must have a color.',
        );
      }
    }

    // Business rule: check if user already has categories
    // This prevents overriding existing categories
    final existingCategories = await _repository.getCategoriesByUserId(
      params.userId,
    );

    if (existingCategories.isNotEmpty) {
      throw const CategoryDataException(
        'User already has categories. Default categories can only be created once.',
      );
    }

    // Business rule: ensure unique category names within default list
    final nameSet = <String>{};
    for (final category in params.defaultCategories) {
      final normalizedName = category.name.trim().toLowerCase();
      if (nameSet.contains(normalizedName)) {
        throw CategoryDataException(
          'Duplicate category name found: "${category.name}". '
          'Default categories must have unique names.',
        );
      }
      nameSet.add(normalizedName);
    }

    // Business rule: ensure no more than max categories
    const maxDefaultCategories = 20;
    if (params.defaultCategories.length > maxDefaultCategories) {
      throw CategoryDataException(
        'Cannot create more than $maxDefaultCategories default categories.',
      );
    }

    // Business rule: at least one income and one expense category
    final hasIncome = params.defaultCategories.any(
      (c) => c.type == CategoryType.income,
    );
    final hasExpense = params.defaultCategories.any(
      (c) => c.type == CategoryType.expense,
    );

    if (!hasIncome || !hasExpense) {
      throw const CategoryDataException(
        'Default categories must include at least one income and one expense category.',
      );
    }

    // Business rule: default categories must be stored with a consistent order
    // This ensures predictable ordering for the repository and data source
    // Income categories first, then expense categories, alphabetically within each group
    final sortedCategories = List<Category>.from(params.defaultCategories)
      ..sort((a, b) {
        // Income categories first
        if (a.type == CategoryType.income && b.type != CategoryType.income) {
          return -1;
        }
        if (a.type != CategoryType.income && b.type == CategoryType.income) {
          return 1;
        }
        // Then alphabetically by name
        return a.name.compareTo(b.name);
      });

    // Delegate to repository
    // The repository will handle:
    // 1. Creating each category with proper IDs and timestamps
    // 2. Setting isDefault flag to true
    // 3. Setting order based on position in list
    final createdCategories = await _repository.createDefaultCategories(
      params.userId,
      sortedCategories,
    );

    return CreateDefaultCategoriesResult(
      categories: createdCategories,
    );
  }
}
