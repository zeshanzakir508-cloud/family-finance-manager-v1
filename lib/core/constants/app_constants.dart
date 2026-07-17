/// ============================================================================
/// Family Finance Manager
/// App Constants
/// ----------------------------------------------------------------------------
/// Contains application-wide constant values.
/// Do NOT store colors, strings, or asset paths here.
/// ============================================================================

class AppConstants {
  AppConstants._();

  //--------------------------------------------------------------------------
  // App Information
  //--------------------------------------------------------------------------

  static const String appName = 'Family Finance Manager';
  static const String appVersion = '1.0.0';

  //--------------------------------------------------------------------------
  // Date & Time
  //--------------------------------------------------------------------------

  static const String defaultDateFormat = 'dd MMM yyyy';
  static const String defaultTimeFormat = 'hh:mm a';
  static const String defaultDateTimeFormat = 'dd MMM yyyy, hh:mm a';

  //--------------------------------------------------------------------------
  // Currency
  //--------------------------------------------------------------------------

  static const String defaultCurrency = 'PKR';
  static const String currencySymbol = 'Rs';

  //--------------------------------------------------------------------------
  // Pagination
  //--------------------------------------------------------------------------

  static const int pageSize = 20;

  //--------------------------------------------------------------------------
  // Validation
  //--------------------------------------------------------------------------

  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  //--------------------------------------------------------------------------
  // Animation
  //--------------------------------------------------------------------------

  static const Duration animationDuration =
      Duration(milliseconds: 300);

  //--------------------------------------------------------------------------
  // Cache
  //--------------------------------------------------------------------------

  static const Duration cacheDuration =
      Duration(hours: 24);
}
