/// ============================================================================
/// Family Finance Manager
/// Firestore Constants
/// ----------------------------------------------------------------------------
/// Centralized Firestore collection and field names.
///
/// Never hardcode collection names or commonly-used field names inside
/// repositories or services.
///
/// Benefits:
/// • Single source of truth
/// • Easier refactoring
/// • Fewer typing mistakes
/// • Better code completion
/// ============================================================================

abstract final class FirestoreConstants {
  FirestoreConstants._();

  //==========================================================================
  // Root Collections
  //==========================================================================

  static const String users = 'users';

  static const String families = 'families';

  static const String accounts = 'accounts';

  static const String categories = 'categories';

  static const String transactions = 'transactions';

  static const String notifications = 'notifications';

  static const String activityLogs = 'activityLogs';

  static const String subscriptions = 'subscriptions';

  static const String settings = 'settings';

  //==========================================================================
  // Common Document Fields
  //==========================================================================

  static const String id = 'id';

  static const String createdAt = 'createdAt';

  static const String updatedAt = 'updatedAt';

  static const String deletedAt = 'deletedAt';

  static const String isDeleted = 'isDeleted';

  static const String version = 'version';

  //==========================================================================
  // User Fields
  //==========================================================================

  static const String displayName = 'displayName';

  static const String email = 'email';

  static const String emailVerified = 'emailVerified';

  static const String phoneNumber = 'phoneNumber';

  static const String photoUrl = 'photoUrl';

  static const String languageCode = 'languageCode';

  static const String appRole = 'appRole';

  static const String accountStatus = 'accountStatus';

  static const String subscriptionStatus = 'subscriptionStatus';

  static const String premiumExpiry = 'premiumExpiry';

  //==========================================================================
  // Family Fields
  //==========================================================================

  static const String familyId = 'familyId';

  static const String ownerId = 'ownerId';

  static const String memberIds = 'memberIds';

  //==========================================================================
  // Account Fields
  //==========================================================================

  static const String accountId = 'accountId';

  static const String accountType = 'accountType';

  static const String balance = 'balance';

  static const String currency = 'currency';

  //==========================================================================
  // Transaction Fields
  //==========================================================================

  static const String transactionId = 'transactionId';

  static const String amount = 'amount';

  static const String transactionType = 'transactionType';

  static const String categoryId = 'categoryId';

  static const String paymentMethod = 'paymentMethod';

  static const String transactionDate = 'transactionDate';

  //==========================================================================
  // Notification Fields
  //==========================================================================

  static const String title = 'title';

  static const String body = 'body';

  static const String isRead = 'isRead';

  //==========================================================================
  // Activity Log Fields
  //==========================================================================

  static const String activityType = 'activityType';

  static const String performedBy = 'performedBy';

  //==========================================================================
  // Settings Fields
  //==========================================================================

  static const String themeMode = 'themeMode';

  static const String locale = 'locale';

  static const String notificationsEnabled = 'notificationsEnabled';
}
