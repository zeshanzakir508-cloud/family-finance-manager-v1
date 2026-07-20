/// Password strength levels.
///
/// Represents the strength of a password based on various criteria.
enum PasswordStrength {
  /// Very weak password
  veryWeak,

  /// Weak password
  weak,

  /// Medium strength password
  medium,

  /// Strong password
  strong,

  /// Very strong password
  veryStrong,
}

/// Extension methods for [PasswordStrength].
extension PasswordStrengthExtension on PasswordStrength {
  /// Returns the display name of the password strength.
  String get displayName {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 'Very Weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  /// Returns the color value for this strength level.
  ///
  /// Note: Replace with AppColors when integrating.
  String get colorHex {
    switch (this) {
      case PasswordStrength.veryWeak:
        return '#FF1744'; // Red
      case PasswordStrength.weak:
        return '#FF9100'; // Orange
      case PasswordStrength.medium:
        return '#FFEA00'; // Yellow
      case PasswordStrength.strong:
        return '#00E676'; // Green
      case PasswordStrength.veryStrong:
        return '#00C853'; // Dark Green
    }
  }

  /// Returns the progress value (0.0 - 1.0) for this strength.
  double get progress {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 0.1;
      case PasswordStrength.weak:
        return 0.3;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.7;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  /// Returns the score value (0-4) for this strength.
  int get score {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 3;
      case PasswordStrength.veryStrong:
        return 4;
    }
  }

  /// Returns true if the password is acceptable for use.
  bool get isAcceptable {
    return this == PasswordStrength.medium ||
        this == PasswordStrength.strong ||
        this == PasswordStrength.veryStrong;
  }

  /// Returns true if the password is strong enough.
  bool get isStrong {
    return this == PasswordStrength.strong ||
        this == PasswordStrength.veryStrong;
  }
}
