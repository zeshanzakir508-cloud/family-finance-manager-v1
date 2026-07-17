/// Defines the type of transaction category.
enum CategoryType {
  income,
  expense,
}

extension CategoryTypeExtension on CategoryType {
  /// String representation used for storage.
  String get value => name;

  bool get isIncome => this == CategoryType.income;

  bool get isExpense => this == CategoryType.expense;

  static CategoryType fromValue(String value) {
    return CategoryType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => CategoryType.expense,
    );
  }
}
