/// ============================================================================
/// Family Finance Manager
/// App Routes
/// ----------------------------------------------------------------------------
/// Centralized application route names.
///
/// Rules:
/// • Never hardcode route strings.
/// • Always use AppRoutes constants.
/// • Group routes by module.
/// ============================================================================

class AppRoutes {
  AppRoutes._();

  //==========================================================================
  // Splash
  //==========================================================================

  static const String splash = '/';

  //==========================================================================
  // Authentication
  //==========================================================================

  static const String login = '/login';

  static const String register = '/register';

  static const String forgotPassword = '/forgot-password';

  static const String verifyEmail = '/verify-email';

  //==========================================================================
  // Dashboard
  //==========================================================================

  static const String dashboard = '/dashboard';

  //==========================================================================
  // Family
  //==========================================================================

  static const String family = '/family';

  static const String familyMembers = '/family-members';

  static const String inviteMember = '/invite-member';

  //==========================================================================
  // Accounts
  //==========================================================================

  static const String accounts = '/accounts';

  static const String addAccount = '/accounts/add';

  static const String editAccount = '/accounts/edit';

  static const String accountDetails = '/accounts/details';

  //==========================================================================
  // Categories
  //==========================================================================

  static const String categories = '/categories';

  static const String addCategory = '/categories/add';

  static const String editCategory = '/categories/edit';

  //==========================================================================
  // Transactions
  //==========================================================================

  static const String transactions = '/transactions';

  static const String addTransaction = '/transactions/add';

  static const String editTransaction = '/transactions/edit';

  static const String transactionDetails = '/transactions/details';

  //==========================================================================
  // Reports
  //==========================================================================

  static const String reports = '/reports';

  static const String analytics = '/analytics';

  //==========================================================================
  // Notifications
  //==========================================================================

  static const String notifications = '/notifications';

  //==========================================================================
  // Subscription
  //==========================================================================

  static const String premium = '/premium';

  //==========================================================================
  // Settings
  //==========================================================================

  static const String settings = '/settings';

  static const String profile = '/profile';

  static const String appSettings = '/app-settings';

  static const String language = '/language';

  static const String theme = '/theme';

  static const String about = '/about';

  //==========================================================================
  // Activity Logs
  //==========================================================================

  static const String activityLogs = '/activity-logs';
}
