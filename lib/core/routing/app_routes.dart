/// ============================================================================
/// Family Finance Manager
/// App Routes
/// ----------------------------------------------------------------------------
/// Centralized route names.
///
/// Always navigate using AppRoutes instead of hardcoded strings.
/// ============================================================================

class AppRoutes {
  AppRoutes._();

  //--------------------------------------------------------------------------
  // Splash
  //--------------------------------------------------------------------------

  static const String splash = '/';

  //--------------------------------------------------------------------------
  // Authentication
  //--------------------------------------------------------------------------

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String createPin = '/create-pin';
  static const String unlockPin = '/unlock-pin';
  static const String profileSetup = '/profile-setup';

  //--------------------------------------------------------------------------
  // Dashboard
  //--------------------------------------------------------------------------

  static const String dashboard = '/dashboard';

  //--------------------------------------------------------------------------
  // Family
  //--------------------------------------------------------------------------

  static const String createFamily = '/family/create';
  static const String joinFamily = '/family/join';
  static const String familyMembers = '/family/members';
  static const String familySettings = '/family/settings';

  //--------------------------------------------------------------------------
  // Accounts
  //--------------------------------------------------------------------------

  static const String accounts = '/accounts';
  static const String addAccount = '/accounts/add';
  static const String editAccount = '/accounts/edit';
  static const String accountDetails = '/accounts/details';

  //--------------------------------------------------------------------------
  // Categories
  //--------------------------------------------------------------------------

  static const String categories = '/categories';
  static const String addCategory = '/categories/add';
  static const String editCategory = '/categories/edit';

  //--------------------------------------------------------------------------
  // Transactions
  //--------------------------------------------------------------------------

  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit';
  static const String transactionDetails = '/transactions/details';
  static const String transactionHistory = '/transactions/history';
  static const String archive = '/transactions/archive';

  //--------------------------------------------------------------------------
  // Reports
  //--------------------------------------------------------------------------

  static const String reports = '/reports';

  //--------------------------------------------------------------------------
  // Notifications
  //--------------------------------------------------------------------------

  static const String notifications = '/notifications';
  static const String activityLog = '/activity-log';

  //--------------------------------------------------------------------------
  // Family Feed
  //--------------------------------------------------------------------------

  static const String familyFeed = '/family-feed';
  static const String createPost = '/family-feed/create-post';
  static const String familyEvents = '/family-feed/events';

  //--------------------------------------------------------------------------
  // Premium
  //--------------------------------------------------------------------------

  static const String premium = '/premium';
  static const String subscriptions = '/subscriptions';

  //--------------------------------------------------------------------------
  // Settings
  //--------------------------------------------------------------------------

  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String security = '/security';
  static const String export = '/export';
  static const String about = '/about';

  //--------------------------------------------------------------------------
  // Developer
  //--------------------------------------------------------------------------

  static const String developerDashboard = '/developer';
  static const String analytics = '/developer/analytics';
  static const String userManagement = '/developer/users';
  static const String adsManagement = '/developer/ads';
}
