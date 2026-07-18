// lib/core/enums/subscription_platform.dart

/// Enum representing platforms where a subscription can be purchased.
enum SubscriptionPlatform {
  /// Android platform (Google Play).
  android,

  /// iOS platform (App Store).
  ios,

  /// Web platform.
  web,

  /// Windows platform.
  windows,

  /// macOS platform.
  macos,

  /// Linux platform.
  linux,

  /// Huawei platform (AppGallery).
  huawei,

  /// Other platform.
  other,
}

/// Extension methods for [SubscriptionPlatform].
extension SubscriptionPlatformExtension on SubscriptionPlatform {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [SubscriptionPlatform] from a stored string value.
  static SubscriptionPlatform fromValue(String value) {
    return SubscriptionPlatform.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubscriptionPlatform.other,
    );
  }

  /// Returns whether this is a mobile platform (Android, iOS, Huawei).
  bool get isMobile {
    return this == SubscriptionPlatform.android ||
        this == SubscriptionPlatform.ios ||
        this == SubscriptionPlatform.huawei;
  }

  /// Returns whether this is a desktop platform (Windows, macOS, Linux).
  bool get isDesktop {
    return this == SubscriptionPlatform.windows ||
        this == SubscriptionPlatform.macos ||
        this == SubscriptionPlatform.linux;
  }

  /// Returns whether this is a web platform.
  bool get isWeb => this == SubscriptionPlatform.web;

  /// Returns whether this is an app store platform (Android, iOS, Huawei).
  bool get isAppStore => isMobile;
}
