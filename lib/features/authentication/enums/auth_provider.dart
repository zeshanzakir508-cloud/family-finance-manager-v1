/// Authentication providers supported by the app.
///
/// Defines the different authentication methods available for
/// signing in or signing up.
enum AuthProvider {
  /// Email and password authentication
  email,

  /// Google OAuth authentication
  google,

  /// Apple OAuth authentication (for iOS/macOS)
  apple,

  /// Facebook OAuth authentication
  facebook,

  /// Phone number authentication (SMS)
  phone,

  /// Biometric authentication (fingerprint/face)
  biometric,
}

/// Extension methods for [AuthProvider].
extension AuthProviderExtension on AuthProvider {
  /// Returns the display name for the provider.
  String get displayName {
    switch (this) {
      case AuthProvider.email:
        return 'Email';
      case AuthProvider.google:
        return 'Google';
      case AuthProvider.apple:
        return 'Apple';
      case AuthProvider.facebook:
        return 'Facebook';
      case AuthProvider.phone:
        return 'Phone';
      case AuthProvider.biometric:
        return 'Biometric';
    }
  }

  /// Returns the icon name for the provider.
  String get iconName {
    switch (this) {
      case AuthProvider.email:
        return 'email';
      case AuthProvider.google:
        return 'google';
      case AuthProvider.apple:
        return 'apple';
      case AuthProvider.facebook:
        return 'facebook';
      case AuthProvider.phone:
        return 'phone';
      case AuthProvider.biometric:
        return 'fingerprint';
    }
  }

  /// Returns true if this provider supports single sign-on.
  bool get isSSO {
    switch (this) {
      case AuthProvider.google:
      case AuthProvider.apple:
      case AuthProvider.facebook:
        return true;
      case AuthProvider.email:
      case AuthProvider.phone:
      case AuthProvider.biometric:
        return false;
    }
  }

  /// Returns true if this provider requires additional setup.
  bool get requiresSetup {
    switch (this) {
      case AuthProvider.biometric:
        return true;
      case AuthProvider.email:
      case AuthProvider.google:
      case AuthProvider.apple:
      case AuthProvider.facebook:
      case AuthProvider.phone:
        return false;
    }
  }
}
