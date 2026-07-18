// lib/domain/usecases/category/reorder_categories_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [ReorderCategoriesUseCase].
class ReorderCategoriesParams extends Equatable {
  final String userId;
  final List<String> categoryIds;

  const ReorderCategoriesParams({
    required this.userId,
    required this.categoryIds,
  });

  @override
  List<Object?> get props => [userId, categoryIds];
}

/// Use case for reordering categories.
///
/// This use case handles updating the order of categories for a user.
/// The order is determined by the position of category IDs in the list.
class ReorderCategoriesUseCase {
  final CategoryRepository _repository;

  const ReorderCategoriesUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the reorder categories use case.
  ///
  /// [params] contains the user ID and the list of category IDs in the desired order.
  /// Throws [CategoryException] if validation fails or reordering fails.
  Future<void> call(ReorderCategoriesParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const CategoryDataException('User ID cannot be empty.');
    }

    // Business rule: category IDs list must not be empty
    if (params.categoryIds.isEmpty) {
      throw const CategoryDataException('Category IDs list cannot be empty.');
    }

    // Business rule: category IDs must be unique
    final uniqueIds = params.categoryIds.toSet();
    if (uniqueIds.length != params.categoryIds.length) {
      throw const CategoryDataException('Category IDs must be unique.');
    }

    // Business rule: category IDs must not contain empty strings
    for (final id in params.categoryIds) {
      if (id.trim().isEmpty) {
        throw const CategoryDataException('Category ID cannot be empty.');
      }
    }

    // Business rule: all categories must belong to the user
    // This will be validated by the repository

    // Business rule: verify all categories exist
    // This will be validated by the repository

    // Delegate to repository
    // The repository handles:
    // 1. Validating all categories belong to the user
    // 2. Validating all categories exist
    // 3. Updating the order field for each category
    // 4. Using a batch write for atomic updates
    await _repository.reorderCategories(
      params.userId.trim(),
      params.categoryIds,
    );
  }
}
