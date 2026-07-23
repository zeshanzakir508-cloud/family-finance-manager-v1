/// Interface for category service operations
abstract class CategoryService {
  /// Get all categories for the current user/family
  Future<List<CategoryModel>> getCategories();

  /// Get categories by family ID
  Future<List<CategoryModel>> getCategoriesByFamily(String familyId);

  /// Get a category by ID
  Future<CategoryModel> getCategory(String categoryId);

  /// Create a new category
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    String icon = 'category',
    String color = '#45B7D1',
    String? familyId,
  });

  /// Update an existing category
  Future<CategoryModel> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    String? icon,
    String? color,
  });

  /// Delete a category
  Future<void> deleteCategory(String categoryId);

  /// Archive a category
  Future<void> archiveCategory(String categoryId);

  /// Restore an archived category
  Future<void> restoreCategory(String categoryId);

  /// Merge categories (move transactions from source to target, then delete source)
  Future<void> mergeCategories({
    required String sourceCategoryId,
    required String targetCategoryId,
  });

  /// Get categories by search query
  Future<List<CategoryModel>> searchCategories(String query);

  /// Get categories by filter (active/archived/all)
  Future<List<CategoryModel>> filterCategories(String filter);

  /// Get category count
  Future<int> getCategoryCount();

  /// Get active category count
  Future<int> getActiveCategoryCount();

  /// Get archived category count
  Future<int> getArchivedCategoryCount();

  /// Check if a category has transactions
  Future<bool> hasTransactions(String categoryId);

  /// Get categories with transaction counts
  Future<List<Map<String, dynamic>>> getCategoriesWithCounts();

  /// Get category by name
  Future<CategoryModel?> getCategoryByName(String name);

  /// Check if category name exists
  Future<bool> categoryNameExists(String name, {String? excludeId});

  /// Get category statistics
  Future<Map<String, dynamic>> getCategoryStatistics();

  /// Sync categories with server
  Future<void> syncCategories();

  /// Listen to category changes
  Stream<List<CategoryModel>> watchCategories();

  /// Listen to category changes by family
  Stream<List<CategoryModel>> watchCategoriesByFamily(String familyId);
}
