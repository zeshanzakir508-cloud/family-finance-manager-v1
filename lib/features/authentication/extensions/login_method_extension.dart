import '../enums/login_method.dart';

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

  /// Returns true if this is a phone-based login.
  bool get isPhoneBased {
    return this == LoginMethod.phone;
  }

  /// Returns true if this method requires user interaction.
  bool get requiresUserInteraction {
    switch (this) {
      case LoginMethod.autoLogin:
      case LoginMethod.refreshToken:
        return false;
      default:
        return true;
    }
  }

  /// Returns the icon name for the login method.
  String get iconName {
    switch (this) {
      case LoginMethod.emailPassword:
        return 'email';
      case LoginMethod.google:
        return 'google';
      case LoginMethod.apple:
        return 'apple';
      case LoginMethod.facebook:
        return 'facebook';
      case LoginMethod.phone:
        return 'phone';
      case LoginMethod.biometric:
        return 'fingerprint';
      case LoginMethod.autoLogin:
        return 'login';
      case LoginMethod.refreshToken:
        return 'refresh';
    }
  }

  /// Returns the asset name for the login method button.
  String get buttonAssetName {
    switch (this) {
      case LoginMethod.google:
        return 'assets/images/google_logo.png';
      case LoginMethod.apple:
        return 'assets/images/apple_logo.png';
      case LoginMethod.facebook:
        return 'assets/images/facebook_logo.png';
      default:
        return '';
    }
  }

  /// Returns the button color for the login method.
  /// Note: Replace with AppColors when integrating.
  String get buttonColorHex {
    switch (this) {
      case LoginMethod.google:
        return '#FFFFFF';
      case LoginMethod.apple:
        return '#000000';
      case LoginMethod.facebook:
        return '#1877F2';
      default:
        return '#1976D2';
    }
  }

  /// Returns the text color for the login method button.
  /// Note: Replace with AppColors when integrating.
  String get textColorHex {
    switch (this) {
      case LoginMethod.google:
        return '#333333';
      case LoginMethod.apple:
        return '#FFFFFF';
      case LoginMethod.facebook:
        return '#FFFFFF';
      default:
        return '#FFFFFF';
    }
  }

  /// Returns true if this method supports "Remember Me".
  bool get supportsRememberMe {
    switch (this) {
      case LoginMethod.emailPassword:
      case LoginMethod.google:
      case LoginMethod.apple:
      case LoginMethod.facebook:
        return true;
      case LoginMethod.phone:
      case LoginMethod.biometric:
      case LoginMethod.autoLogin:
      case LoginMethod.refreshToken:
        return false;
    }
  }

  /// Returns the analytics event name for the login method.
  String get analyticsEventName {
    return 'login_${name}';
  }
}
