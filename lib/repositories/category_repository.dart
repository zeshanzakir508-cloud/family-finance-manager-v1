import '../models/category_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Category Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing transaction categories.
///
/// Responsibilities:
/// • Create category
/// • Read category(s)
/// • Update category
/// • Soft delete category
/// • Restore category
/// • Watch category changes
/// • Enable/Disable categories
/// • Manage system & custom categories
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class CategoryRepository {
  //==========================================================================
  // Category
  //==========================================================================

  /// Creates a new category.
  Future<void> createCategory(CategoryModel category);

  /// Returns a category by its ID.
  Future<CategoryModel?> getCategory(String categoryId);

  /// Returns all categories belonging to a family.
  Future<List<CategoryModel>> getCategories(String familyId);

  /// Watches a category.
  Stream<CategoryModel?> watchCategory(String categoryId);

  /// Watches all categories of a family.
  Stream<List<CategoryModel>> watchCategories(String familyId);

  /// Updates an existing category.
  Future<void> updateCategory(CategoryModel category);

  /// Soft deletes a category.
  Future<void> deleteCategory(String categoryId);

  /// Restores a deleted category.
  Future<void> restoreCategory(String categoryId);

  /// Returns true if the category exists.
  Future<bool> categoryExists(String categoryId);

  //==========================================================================
  // Category Status
  //==========================================================================

  /// Enables a category.
  Future<void> enableCategory(String categoryId);

  /// Disables a category.
  Future<void> disableCategory(String categoryId);

  /// Returns whether the category is currently active.
  Future<bool> isCategoryEnabled(String categoryId);

  //==========================================================================
  // Defaults
  //==========================================================================

  /// Creates the default categories for a newly created family.
  Future<void> createDefaultCategories(String familyId);

  /// Returns all built-in system categories.
  Future<List<CategoryModel>> getSystemCategories();
}
