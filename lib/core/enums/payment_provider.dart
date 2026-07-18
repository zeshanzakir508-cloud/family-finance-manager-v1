// lib/core/enums/payment_provider.dart

/// Enum representing payment providers.
enum PaymentProvider {
  /// Stripe payment provider.
  stripe,

  /// Google Play Store billing.
  googlePlay,

  /// Apple App Store billing.
  apple,

  /// JazzCash mobile wallet.
  jazzCash,

  /// EasyPaisa mobile wallet.
  easyPaisa,

  /// PayPal payment provider.
  paypal,
}

/// Extension methods for [PaymentProvider].
extension PaymentProviderExtension on PaymentProvider {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [PaymentProvider] from a stored string value.
  static PaymentProvider fromValue(String value) {
    return PaymentProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentProvider.stripe,
    );
  }

  /// Returns whether this is a mobile wallet provider.
  bool get isMobileWallet {
    return this == PaymentProvider.jazzCash ||
        this == PaymentProvider.easyPaisa;
  }

  /// Returns whether this is an app store provider.
  bool get isAppStore {
    return this == PaymentProvider.googlePlay ||
        this == PaymentProvider.apple;
  }

  /// Returns whether this is an international provider.
  bool get isInternationalProvider {
    return this == PaymentProvider.stripe ||
        this == PaymentProvider.paypal;
  }

  /// Returns whether this is a Pakistani provider.
  bool get isPakistaniProvider {
    return this == PaymentProvider.jazzCash ||
        this == PaymentProvider.easyPaisa;
  }
}
