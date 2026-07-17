/// Defines supported transaction types.
enum TransactionType {
  income,
  expense,
  transfer,
}

extension TransactionTypeExtension on TransactionType {
  String get value => name;

  bool get isIncome => this == TransactionType.income;

  bool get isExpense => this == TransactionType.expense;

  bool get isTransfer => this == TransactionType.transfer;

  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TransactionType.expense,
    );
  }
}
