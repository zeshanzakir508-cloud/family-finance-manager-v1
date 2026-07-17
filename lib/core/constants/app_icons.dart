import 'package:flutter/material.dart';

/// ============================================================================
/// Family Finance Manager
/// App Icons
/// ----------------------------------------------------------------------------
/// Centralized Material icons used throughout the application.
///
/// Always use AppIcons instead of Icons directly.
/// This keeps the UI consistent and makes future icon replacement easier.
/// ============================================================================

class AppIcons {
  AppIcons._();

  //--------------------------------------------------------------------------
  // Navigation
  //--------------------------------------------------------------------------

  static const IconData home = Icons.home_rounded;
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData forward = Icons.arrow_forward_rounded;

  //--------------------------------------------------------------------------
  // Authentication
  //--------------------------------------------------------------------------

  static const IconData login = Icons.login_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData person = Icons.person_rounded;
  static const IconData personAdd = Icons.person_add_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline_rounded;
  static const IconData visibility = Icons.visibility_rounded;
  static const IconData visibilityOff = Icons.visibility_off_rounded;
  static const IconData security = Icons.security_rounded;

  //--------------------------------------------------------------------------
  // Family
  //--------------------------------------------------------------------------

  static const IconData family = Icons.family_restroom_rounded;
  static const IconData group = Icons.group_rounded;
  static const IconData member = Icons.person_outline_rounded;

  //--------------------------------------------------------------------------
  // Accounts
  //--------------------------------------------------------------------------

  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData bank = Icons.account_balance_rounded;
  static const IconData cash = Icons.payments_rounded;
  static const IconData creditCard = Icons.credit_card_rounded;

  //--------------------------------------------------------------------------
  // Transactions
  //--------------------------------------------------------------------------

  static const IconData income = Icons.arrow_downward_rounded;
  static const IconData expense = Icons.arrow_upward_rounded;
  static const IconData transfer = Icons.swap_horiz_rounded;
  static const IconData history = Icons.history_rounded;
  static const IconData receipt = Icons.receipt_long_rounded;

  //--------------------------------------------------------------------------
  // Categories
  //--------------------------------------------------------------------------

  static const IconData category = Icons.category_rounded;
  static const IconData label = Icons.label_rounded;

  //--------------------------------------------------------------------------
  // Reports
  //--------------------------------------------------------------------------

  static const IconData reports = Icons.assessment_rounded;
  static const IconData pieChart = Icons.pie_chart_rounded;
  static const IconData barChart = Icons.bar_chart_rounded;
  static const IconData analytics = Icons.analytics_rounded;

  //--------------------------------------------------------------------------
  // Notifications
  //--------------------------------------------------------------------------

  static const IconData notifications = Icons.notifications_rounded;
  static const IconData activity = Icons.timeline_rounded;

  //--------------------------------------------------------------------------
  // Settings
  //--------------------------------------------------------------------------

  static const IconData settings = Icons.settings_rounded;
  static const IconData theme = Icons.palette_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData help = Icons.help_outline_rounded;

  //--------------------------------------------------------------------------
  // Common Actions
  //--------------------------------------------------------------------------

  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData save = Icons.save_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData upload = Icons.upload_rounded;
  static const IconData calendar = Icons.calendar_month_rounded;
  static const IconData time = Icons.access_time_rounded;

  //--------------------------------------------------------------------------
  // Status
  //--------------------------------------------------------------------------

  static const IconData success = Icons.check_circle_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData infoCircle = Icons.info_rounded;
}
