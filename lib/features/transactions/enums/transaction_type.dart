/// Enum representing the type of transaction
enum TransactionType {
  income,
  expense,
  transfer,
}

/// Extension methods for TransactionType
extension TransactionTypeExtension on TransactionType {
  /// Get the display name for the type
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  /// Get the icon for the type
  String get iconName {
    switch (this) {
      case TransactionType.income:
        return 'arrow_upward';
      case TransactionType.expense:
        return 'arrow_downward';
      case TransactionType.transfer:
        return 'swap_horiz';
    }
  }

  /// Get the color for the type
  String get colorHex {
    switch (this) {
      case TransactionType.income:
        return '#4CAF50';
      case TransactionType.expense:
        return '#F44336';
      case TransactionType.transfer:
        return '#2196F3';
    }
  }

  /// Check if this type is income
  bool get isIncome => this == TransactionType.income;

  /// Check if this type is expense
  bool get isExpense => this == TransactionType.expense;

  /// Check if this type is transfer
  bool get isTransfer => this == TransactionType.transfer;

  /// Get the type from string value
  static TransactionType fromString(String value) {
    return values.firstWhere(
      (type) => type.name == value,
      orElse: () => TransactionType.expense,
    );
  }

  /// Get all types
  static List<TransactionType> get allTypes => values;

  /// Get income and expense types (non-transfer)
  static List<TransactionType> get nonTransferTypes =>
      values.where((t) => t != TransactionType.transfer).toList();

  /// Parse type from string (case-insensitive)
  static TransactionType parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in values) {
      if (type.name.toLowerCase() == lowerValue) {
        return type;
      }
      if (type.displayName.toLowerCase() == lowerValue) {
        return type;
      }
    }
    return TransactionType.expense;
  }
}
