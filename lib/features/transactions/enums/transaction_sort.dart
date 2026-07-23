/// Enum representing sort options for transactions
enum TransactionSort {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
  categoryAsc,
  categoryDesc,
}

/// Extension methods for TransactionSort
extension TransactionSortExtension on TransactionSort {
  /// Get the display name for the sort option
  String get displayName {
    switch (this) {
      case TransactionSort.dateDesc:
        return 'Newest First';
      case TransactionSort.dateAsc:
        return 'Oldest First';
      case TransactionSort.amountDesc:
        return 'Highest Amount';
      case TransactionSort.amountAsc:
        return 'Lowest Amount';
      case TransactionSort.categoryAsc:
        return 'Category A-Z';
      case TransactionSort.categoryDesc:
        return 'Category Z-A';
    }
  }

  /// Get the icon for the sort option
  String get iconName {
    switch (this) {
      case TransactionSort.dateDesc:
        return 'arrow_downward';
      case TransactionSort.dateAsc:
        return 'arrow_upward';
      case TransactionSort.amountDesc:
        return 'arrow_downward';
      case TransactionSort.amountAsc:
        return 'arrow_upward';
      case TransactionSort.categoryAsc:
        return 'arrow_upward';
      case TransactionSort.categoryDesc:
        return 'arrow_downward';
    }
  }

  /// Check if this is a date sort
  bool get isDateSort {
    return this == TransactionSort.dateDesc || 
           this == TransactionSort.dateAsc;
  }

  /// Check if this is an amount sort
  bool get isAmountSort {
    return this == TransactionSort.amountDesc || 
           this == TransactionSort.amountAsc;
  }

  /// Check if this is a category sort
  bool get isCategorySort {
    return this == TransactionSort.categoryAsc || 
           this == TransactionSort.categoryDesc;
  }

  /// Get the sort direction (true = ascending)
  bool get isAscending {
    switch (this) {
      case TransactionSort.dateDesc:
        return false;
      case TransactionSort.dateAsc:
        return true;
      case TransactionSort.amountDesc:
        return false;
      case TransactionSort.amountAsc:
        return true;
      case TransactionSort.categoryAsc:
        return true;
      case TransactionSort.categoryDesc:
        return false;
    }
  }

  /// Get the sort field
  String get field {
    switch (this) {
      case TransactionSort.dateDesc:
      case TransactionSort.dateAsc:
        return 'date';
      case TransactionSort.amountDesc:
      case TransactionSort.amountAsc:
        return 'amount';
      case TransactionSort.categoryAsc:
      case TransactionSort.categoryDesc:
        return 'categoryName';
    }
  }

  /// Get all sort options
  static List<TransactionSort> get allSorts => values;

  /// Get default sort
  static TransactionSort get defaultSort => TransactionSort.dateDesc;

  /// Parse sort from string (case-insensitive)
  static TransactionSort parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final sort in values) {
      if (sort.name.toLowerCase() == lowerValue) {
        return sort;
      }
      if (sort.displayName.toLowerCase() == lowerValue) {
        return sort;
      }
    }
    return defaultSort;
  }
}
