/// Defines supported financial account types.
enum AccountType {
  cash,
  bank,
  mobileWallet,
}

/// Convenience extensions for [AccountType].
extension AccountTypeExtension on AccountType {
  /// String representation used for storage.
  String get value => name;

  bool get isCash => this == AccountType.cash;

  bool get isBank => this == AccountType.bank;

  bool get isMobileWallet => this == AccountType.mobileWallet;

  static AccountType fromValue(String value) {
    return AccountType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => AccountType.cash,
    );
  }
}
