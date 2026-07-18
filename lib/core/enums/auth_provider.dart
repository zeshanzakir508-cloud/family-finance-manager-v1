// lib/core/enums/auth_provider.dart

/// Enum representing authentication providers.
enum AuthProvider {
  /// Email/password authentication.
  email,

  /// Google Sign-In.
  google,

  /// Apple Sign-In.
  apple,

  /// Facebook Sign-In.
  facebook,

  /// Anonymous authentication.
  anonymous,
}

/// Extension methods for [AuthProvider].
extension AuthProviderExtension on AuthProvider {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates an [AuthProvider] from a stored string value.
  static AuthProvider fromValue(String value) {
    return AuthProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuthProvider.email,
    );
  }

  /// Returns whether this is a social authentication provider.
  bool get isSocialProvider {
    return this == AuthProvider.google ||
        this == AuthProvider.apple ||
        this == AuthProvider.facebook;
  }

  /// Returns whether this is an email-based provider.
  bool get isEmailProvider => this == AuthProvider.email;

  /// Returns whether this is an anonymous provider.
  bool get isAnonymousProvider => this == AuthProvider.anonymous;
}
