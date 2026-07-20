/// Authentication regex patterns for validation.
///
/// Contains regular expressions used for validating user input
/// in authentication flows (email, password, phone, etc.).
class AuthRegex {
  AuthRegex._();

  //--------------------------------------------------------------------------
  // Email
  //--------------------------------------------------------------------------

  /// Email validation regex pattern.
  ///
  /// Validates standard email formats with domain extensions.
  /// Supports:
  /// - Letters, numbers, dots, underscores, hyphens in local part
  /// - Domain with at least one dot and valid extension
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  //--------------------------------------------------------------------------
  // Password
  //--------------------------------------------------------------------------

  /// Password strength regex patterns.
  ///
  /// These patterns are used to validate different aspects of password strength.

  /// At least one uppercase letter
  static final RegExp hasUppercase = RegExp(r'[A-Z]');

  /// At least one lowercase letter
  static final RegExp hasLowercase = RegExp(r'[a-z]');

  /// At least one digit/number
  static final RegExp hasNumber = RegExp(r'[0-9]');

  /// At least one special character
  static final RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  /// Password must contain only allowed characters
  static final RegExp allowedPasswordChars = RegExp(r'^[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]+$');

  //--------------------------------------------------------------------------
  // Phone
  //--------------------------------------------------------------------------

  /// Phone number validation regex pattern.
  ///
  /// Supports international phone numbers with:
  /// - Optional '+' at start
  /// - Country code (1-3 digits)
  /// - Space, dash, or dot separators
  /// - 7-15 digits total
  static final RegExp phone = RegExp(
    r'^\+?[0-9]{1,3}[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$',
  );

  //--------------------------------------------------------------------------
  // Username
  //--------------------------------------------------------------------------

  /// Username validation regex pattern.
  ///
  /// Allows:
  /// - Letters (both cases)
  /// - Numbers
  /// - Underscores
  /// - Dots
  /// - Must start with a letter
  /// - Minimum 3 characters, maximum 30
  static final RegExp username = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_.]{2,29}$',
  );

  /// Username allows only alphanumeric and underscore/dot
  static final RegExp usernameAllowedChars = RegExp(
    r'^[a-zA-Z0-9_.]+$',
  );

  //--------------------------------------------------------------------------
  // Name
  //--------------------------------------------------------------------------

  /// Full name validation regex pattern.
  ///
  /// Allows:
  /// - Letters (including unicode)
  /// - Spaces
  /// - Hyphens
  /// - Dots
  /// - Apostrophes
  static final RegExp fullName = RegExp(
    r"^[a-zA-Z\u00C0-\u017F'\-.\s]{2,50}$",
  );

  //--------------------------------------------------------------------------
  // OTP
  //--------------------------------------------------------------------------

  /// OTP validation regex pattern.
  ///
  /// Exactly 6 digits for security.
  static final RegExp otp = RegExp(r'^[0-9]{6}$');

  //--------------------------------------------------------------------------
  // URL
  //--------------------------------------------------------------------------

  /// URL validation regex pattern.
  ///
  /// Validates HTTP/HTTPS URLs.
  static final RegExp url = RegExp(
    r'^https?://[a-zA-Z0-9\-._~:/?#[\]@!$&\'()*+,;=]+$',
  );

  //--------------------------------------------------------------------------
  // UUID
  //--------------------------------------------------------------------------

  /// UUID validation regex pattern.
  ///
  /// Validates standard UUID v4 format.
  static final RegExp uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );
}
