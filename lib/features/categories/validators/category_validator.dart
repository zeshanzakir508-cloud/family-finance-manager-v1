/// Validator for category-related data
class CategoryValidator {
  /// Validation result for category name
  static ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Category name is required',
      );
    }

    final trimmed = name.trim();
    
    if (trimmed.length < 2) {
      return ValidationResult(
        isValid: false,
        message: 'Category name must be at least 2 characters',
      );
    }
    
    if (trimmed.length > 30) {
      return ValidationResult(
        isValid: false,
        message: 'Category name must be less than 30 characters',
      );
    }

    // Check for invalid characters (only alphanumeric, spaces, and basic punctuation)
    final regex = RegExp(r'^[a-zA-Z0-9\s\-&\'"]{2,30}$');
    if (!regex.hasMatch(trimmed)) {
      return ValidationResult(
        isValid: false,
        message: 'Category name contains invalid characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate category description
  static ValidationResult validateDescription(String? description) {
    if (description == null) {
      return ValidationResult(isValid: true);
    }

    if (description.length > 200) {
      return ValidationResult(
        isValid: false,
        message: 'Description must be less than 200 characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate duplicate category name
  static ValidationResult validateDuplicateName(
    String name,
    List<CategoryModel> existingCategories, {
    String? excludeId,
  }) {
    final exists = existingCategories.any((c) =>
        c.name.toLowerCase() == name.toLowerCase() &&
        c.id != excludeId);
    
    if (exists) {
      return ValidationResult(
        isValid: false,
        message: 'A category with this name already exists',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate category deletion (check if in use)
  static ValidationResult validateDeleteCategory(
    CategoryModel category,
    bool isInUse,
  ) {
    if (isInUse) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot delete category: It is used by transactions. Please merge or reassign first.',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate category merge
  static ValidationResult validateMergeCategories(
    CategoryModel? sourceCategory,
    CategoryModel? targetCategory,
  ) {
    if (sourceCategory == null) {
      return ValidationResult(
        isValid: false,
        message: 'Source category not found',
      );
    }

    if (targetCategory == null) {
      return ValidationResult(
        isValid: false,
        message: 'Target category not found',
      );
    }

    if (sourceCategory.id == targetCategory.id) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot merge a category with itself',
      );
    }

    if (sourceCategory.isArchived) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot merge from an archived category',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate category search query
  static ValidationResult validateSearchQuery(String? query) {
    if (query == null || query.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Search query is required',
      );
    }

    if (query.trim().length < 2) {
      return ValidationResult(
        isValid: false,
        message: 'Search query must be at least 2 characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate category filter
  static ValidationResult validateFilter(String? filter) {
    final validFilters = ['all', 'active', 'archived'];
    if (filter != null && !validFilters.contains(filter)) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid filter option',
      );
    }
    return ValidationResult(isValid: true);
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? message;

  const ValidationResult({
    required this.isValid,
    this.message,
  });
}
