import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// ============================================================================
/// Family Finance Manager
/// Formatters
/// ----------------------------------------------------------------------------
/// Centralized formatting utilities.
///
/// NOTE:
/// Requires the `intl` package.
/// ============================================================================

class Formatters {
  Formatters._();

  //--------------------------------------------------------------------------
  // Currency
  //--------------------------------------------------------------------------

  static String currency(
    num value, {
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: AppConstants.locale,
      symbol: AppConstants.currencySymbol,
      decimalDigits: decimalDigits,
    );

    return formatter.format(value);
  }

  //--------------------------------------------------------------------------
  // Number
  //--------------------------------------------------------------------------

  static String number(
    num value, {
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.decimalPattern(
      AppConstants.locale,
    );

    if (decimalDigits == 0) {
      return formatter.format(value.round());
    }

    return NumberFormat.decimalPatternDigits(
      locale: AppConstants.locale,
      decimalDigits: decimalDigits,
    ).format(value);
  }

  //--------------------------------------------------------------------------
  // Percentage
  //--------------------------------------------------------------------------

  static String percentage(
    num value, {
    int decimalDigits = 1,
  }) {
    return '${value.toStringAsFixed(decimalDigits)}%';
  }

  //--------------------------------------------------------------------------
  // Date
  //--------------------------------------------------------------------------

  static String date(
    DateTime date, {
    String? pattern,
  }) {
    return DateFormat(
      pattern ?? AppConstants.dateFormat,
      AppConstants.locale,
    ).format(date);
  }

  //--------------------------------------------------------------------------
  // Time
  //--------------------------------------------------------------------------

  static String time(
    DateTime dateTime, {
    String? pattern,
  }) {
    return DateFormat(
      pattern ?? AppConstants.timeFormat,
      AppConstants.locale,
    ).format(dateTime);
  }

  //--------------------------------------------------------------------------
  // Date & Time
  //--------------------------------------------------------------------------

  static String dateTime(
    DateTime dateTime, {
    String? pattern,
  }) {
    return DateFormat(
      pattern ?? AppConstants.dateTimeFormat,
      AppConstants.locale,
    ).format(dateTime);
  }

  //--------------------------------------------------------------------------
  // Month & Year
  //--------------------------------------------------------------------------

  static String monthYear(DateTime date) {
    return DateFormat(
      AppConstants.monthYearFormat,
      AppConstants.locale,
    ).format(date);
  }

  //--------------------------------------------------------------------------
  // Short Date
  //--------------------------------------------------------------------------

  static String shortDate(DateTime date) {
    return DateFormat(
      AppConstants.shortDateFormat,
      AppConstants.locale,
    ).format(date);
  }

  //--------------------------------------------------------------------------
  // File Timestamp
  //--------------------------------------------------------------------------

  static String fileTimestamp(DateTime dateTime) {
    return DateFormat(
      AppConstants.fileTimestampFormat,
      AppConstants.locale,
    ).format(dateTime);
  }
}
