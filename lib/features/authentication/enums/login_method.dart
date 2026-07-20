/// Login method used for authentication.
///
/// Defines the method used to log in, useful for tracking
/// and analytics purposes.
enum LoginMethod {
  /// Email and password login
  emailPassword,

  /// Google OAuth login
  google,

  /// Apple OAuth login
  apple,

  /// Facebook OAuth login
  facebook,

  /// Phone number login
  phone,

  /// Biometric login
  biometric,

  /// Auto-login using stored session
  autoLogin,

  /// Login using refresh token
  refreshToken,
}

/// Extension methods for [LoginMethod].
extension LoginMethodExtension on LoginMethod {
  /// Returns the display name of the login method.
  String get displayName {
    switch (this) {
      case LoginMethod.emailPassword:
        return 'Email & Password';
      case LoginMethod.google:
        return 'Google';
      case LoginMethod.apple:
        return 'Apple';
      case LoginMethod.facebook:
        return 'Facebook';
      case LoginMethod.phone:
        return 'Phone';
      case LoginMethod.biometric:
        return 'Biometric';
      case LoginMethod.autoLogin:
        return 'Auto Login';
      case LoginMethod.refreshToken:
        return 'Refresh Token';
    }
  }

  /// Returns true if this is a social login method.
  bool get isSocial {
    switch (this) {
      case LoginMethod.google:
      case LoginMethod.apple:
      case LoginMethod.facebook:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if this is a password-based login.
  bool get isPasswordBased {
    return this == LoginMethod.emailPassword;
  }

  /// Returns true if this is a biometric login.
  bool get isBiometric {
    return this == LoginMethod.biometric;
  }

  /// Returns true if this is an automatic login.
  bool get isAutoLogin {
    return this == LoginMethod.autoLogin ||
        this == LoginMethod.refreshToken;
  }
}
