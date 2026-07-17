/// Defines how a transaction was paid.
enum PaymentMethod {
  cash,
  bank,
  mobileWallet,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get value => name;

  bool get isCash => this == PaymentMethod.cash;

  bool get isBank => this == PaymentMethod.bank;

  bool get isMobileWallet => this == PaymentMethod.mobileWallet;

  bool get isOther => this == PaymentMethod.other;

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.name == value,
      orElse: () => PaymentMethod.other,
    );
  }
}
