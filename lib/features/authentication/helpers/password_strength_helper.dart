import '../enums/password_strength.dart';
import '../constants/auth_constants.dart';
import '../constants/auth_regex.dart';

/// Helper for calculating and analyzing password strength.
class PasswordStrengthHelper {
  PasswordStrengthHelper._();

  /// Calculates the strength of a password.
  static PasswordStrength calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (AuthRegex.hasUppercase.hasMatch(password)) score++;
    if (AuthRegex.hasLowercase.hasMatch(password)) score++;
    if (AuthRegex.hasNumber.hasMatch(password)) score++;
    if (AuthRegex.hasSpecialChar.hasMatch(password)) score++;

    // Determine strength based on score
    if (score <= 2) return PasswordStrength.veryWeak;
    if (score <= 3) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Returns a list of requirements for a strong password.
  static List<String> getRequirements() {
    return [
      'At least ${AuthConstants.minPasswordLength} characters',
      'At least one uppercase letter',
      'At least one lowercase letter',
      'At least one number',
      'At least one special character',
    ];
  }

  /// Checks if a password meets all requirements.
  static bool meetsAllRequirements(String password) {
    if (password.length < AuthConstants.minPasswordLength) return false;
    if (!AuthRegex.hasUppercase.hasMatch(password)) return false;
    if (!AuthRegex.hasLowercase.hasMatch(password)) return false;
    if (!AuthRegex.hasNumber.hasMatch(password)) return false;
    if (!AuthRegex.hasSpecialChar.hasMatch(password)) return false;
    return true;
  }

  /// Gets the missing requirements for a password.
  static List<String> getMissingRequirements(String password) {
    final missing = <String>[];

    if (password.length < AuthConstants.minPasswordLength) {
      missing.add('At least ${AuthConstants.minPasswordLength} characters');
    }
    if (!AuthRegex.hasUppercase.hasMatch(password)) {
      missing.add('At least one uppercase letter');
    }
    if (!AuthRegex.hasLowercase.hasMatch(password)) {
      missing.add('At least one lowercase letter');
    }
    if (!AuthRegex.hasNumber.hasMatch(password)) {
      missing.add('At least one number');
    }
    if (!AuthRegex.hasSpecialChar.hasMatch(password)) {
      missing.add('At least one special character');
    }

    return missing;
  }

  /// Returns the strength progress (0.0 - 1.0).
  static double getStrengthProgress(PasswordStrength strength) {
    return strength.progress;
  }

  /// Returns the strength score (0-4).
  static int getStrengthScore(PasswordStrength strength) {
    return strength.score;
  }

  /// Returns true if the password is acceptable for use.
  static bool isAcceptable(PasswordStrength strength) {
    return strength.isAcceptable;
  }

  /// Returns true if the password is strong enough.
  static bool isStrong(PasswordStrength strength) {
    return strength.isStrong;
  }

  /// Gets the color for password strength indicator.
  static String getStrengthColor(PasswordStrength strength) {
    return strength.colorHex;
  }

  /// Gets a description for the password strength.
  static String getStrengthDescription(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 'Very Weak - Consider adding more characters and variety';
      case PasswordStrength.weak:
        return 'Weak - Add more variety to strengthen';
      case PasswordStrength.medium:
        return 'Medium - Good, but could be stronger';
      case PasswordStrength.strong:
        return 'Strong - Great password';
      case PasswordStrength.veryStrong:
        return 'Very Strong - Excellent password';
    }
  }

  /// Gets the number of common password patterns.
  static int getCommonPatternsCount(String password) {
    int count = 0;
    final lower = password.toLowerCase();

    // Common patterns
    if (lower.contains('password')) count++;
    if (lower.contains('123456')) count++;
    if (lower.contains('qwerty')) count++;
    if (lower.contains('admin')) count++;
    if (lower.contains('letmein')) count++;
    if (lower.contains('welcome')) count++;
    if (lower.contains('monkey')) count++;
    if (lower.contains('dragon')) count++;
    if (lower.contains('master')) count++;
    if (lower.contains('love')) count++;

    return count;
  }

  /// Checks if a password contains common patterns.
  static bool hasCommonPatterns(String password) {
    return getCommonPatternsCount(password) > 0;
  }
}
