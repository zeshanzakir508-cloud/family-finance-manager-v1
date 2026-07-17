class AppConstants {
  AppConstants._();

  //--------------------------------------------------------------------------
  // App
  //--------------------------------------------------------------------------

  static const String appName = 'Family Finance Manager';

  //--------------------------------------------------------------------------
  // Localization
  //--------------------------------------------------------------------------

  static const String locale = 'en_PK';

  static const String defaultLanguageCode = 'en';
  static const String defaultCountryCode = 'PK';

  //--------------------------------------------------------------------------
  // Currency
  //--------------------------------------------------------------------------

  static const String currencyCode = 'PKR';
  static const String currencySymbol = 'Rs';

  //--------------------------------------------------------------------------
  // Date & Time Formats
  //--------------------------------------------------------------------------

  static const String dateFormat = 'dd MMM yyyy';

  static const String shortDateFormat = 'dd/MM/yyyy';

  static const String timeFormat = 'hh:mm a';

  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  static const String monthYearFormat = 'MMMM yyyy';

  static const String fileTimestampFormat = 'yyyyMMdd_HHmmss';

  //--------------------------------------------------------------------------
  // Pagination
  //--------------------------------------------------------------------------

  static const int pageSize = 20;

  //--------------------------------------------------------------------------
  // Validation
  //--------------------------------------------------------------------------

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  static const int maxDescriptionLength = 500;

  //--------------------------------------------------------------------------
  // Animation
  //--------------------------------------------------------------------------

  static const Duration animationDuration =
      Duration(milliseconds: 300);

  //--------------------------------------------------------------------------
  // UI
  //--------------------------------------------------------------------------

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;

  //--------------------------------------------------------------------------
  // Cache
  //--------------------------------------------------------------------------

  static const Duration cacheDuration =
      Duration(hours: 24);
}
