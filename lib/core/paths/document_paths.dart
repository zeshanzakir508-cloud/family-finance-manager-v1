/// ============================================================================
/// Family Finance Manager
/// Document Paths
/// ----------------------------------------------------------------------------
/// Centralized Firestore document and collection path helpers.
///
/// Benefits:
/// • No hardcoded Firestore paths
/// • Compile-time autocomplete
/// • Easier refactoring
/// • Consistent path generation
///
/// NOTE:
/// Root collection names come from FirestoreConstants.
/// ============================================================================

import '../constants/firestore_constants.dart';

abstract final class DocumentPaths {
  DocumentPaths._();

  //==========================================================================
  // Root Collections
  //==========================================================================

  static const String users = FirestoreConstants.users;

  static const String families = FirestoreConstants.families;

  static const String accounts = FirestoreConstants.accounts;

  static const String categories = FirestoreConstants.categories;

  static const String transactions = FirestoreConstants.transactions;

  static const String notifications = FirestoreConstants.notifications;

  static const String activityLogs = FirestoreConstants.activityLogs;

  static const String subscriptions = FirestoreConstants.subscriptions;

  static const String settings = FirestoreConstants.settings;

  //==========================================================================
  // Collection Paths
  //==========================================================================

  static String usersCollection() => users;

  static String familiesCollection() => families;

  static String accountsCollection() => accounts;

  static String categoriesCollection() => categories;

  static String transactionsCollection() => transactions;

  static String notificationsCollection() => notifications;

  static String activityLogsCollection() => activityLogs;

  static String subscriptionsCollection() => subscriptions;

  static String settingsCollection() => settings;

  //==========================================================================
  // User
  //==========================================================================

  static String user(String userId) => '$users/$userId';

  //==========================================================================
  // Family
  //==========================================================================

  static String family(String familyId) => '$families/$familyId';

  //==========================================================================
  // Account
  //==========================================================================

  static String account(String accountId) => '$accounts/$accountId';

  //==========================================================================
  // Category
  //==========================================================================

  static String category(String categoryId) =>
      '$categories/$categoryId';

  //==========================================================================
  // Transaction
  //==========================================================================

  static String transaction(String transactionId) =>
      '$transactions/$transactionId';

  //==========================================================================
  // Notification
  //==========================================================================

  static String notification(String notificationId) =>
      '$notifications/$notificationId';

  //==========================================================================
  // Activity Log
  //==========================================================================

  static String activityLog(String activityLogId) =>
      '$activityLogs/$activityLogId';

  //==========================================================================
  // Subscription
  //==========================================================================

  static String subscription(String userId) =>
      '$subscriptions/$userId';

  //==========================================================================
  // Settings
  //==========================================================================

  static String settingsDocument(String userId) =>
      '$settings/$userId';

  //==========================================================================
  // Generic Helpers
  //==========================================================================

  static String document({
    required String collection,
    required String documentId,
  }) {
    return '$collection/$documentId';
  }

  static String childCollection({
    required String parentDocumentPath,
    required String collection,
  }) {
    return '$parentDocumentPath/$collection';
  }

  static String childDocument({
    required String parentDocumentPath,
    required String collection,
    required String documentId,
  }) {
    return '$parentDocumentPath/$collection/$documentId';
  }
}
