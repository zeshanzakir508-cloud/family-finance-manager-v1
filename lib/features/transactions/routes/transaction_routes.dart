import 'package:flutter/material.dart';
import '../views/pages/transactions_page.dart';
import '../views/pages/add_transaction_page.dart';
import '../views/pages/edit_transaction_page.dart';
import '../views/pages/transaction_details_page.dart';
import '../views/pages/recurring_transactions_page.dart';

/// Route names for the Transactions feature
class TransactionRoutes {
  static const String home = '/transactions';
  static const String details = '/transactions/details';
  static const String add = '/transactions/add';
  static const String edit = '/transactions/edit';
  static const String recurring = '/transactions/recurring';

  /// Get all routes
  static List<String> get allRoutes => [
        home,
        details,
        add,
        edit,
        recurring,
      ];

  /// Check if a route is a transactions route
  static bool isTransactionsRoute(String route) {
    return route.startsWith('/transactions');
  }

  /// Get the route for transaction details
  static String getTransactionDetailsRoute(String transactionId) {
    return '$details?transactionId=$transactionId';
  }

  /// Get the route for editing a transaction
  static String getEditTransactionRoute(String transactionId) {
    return '$edit?transactionId=$transactionId';
  }

  /// Get the route for adding a transaction with presets
  static String getAddTransactionRoute({
    String? accountId,
    String? categoryId,
    String? type,
  }) {
    var route = add;
    final params = <String>[];
    if (accountId != null) {
      params.add('accountId=$accountId');
    }
    if (categoryId != null) {
      params.add('categoryId=$categoryId');
    }
    if (type != null) {
      params.add('type=$type');
    }
    if (params.isNotEmpty) {
      route = '$add?${params.join('&')}';
    }
    return route;
  }
}

/// Route configuration for transactions feature
class TransactionRouteConfig {
  /// Build a route for transactions
  static Widget buildRoute(BuildContext context, RouteSettings settings) {
    final routeName = settings.name ?? '';
    final arguments = settings.arguments as Map<String, dynamic>?;

    // Extract parameters
    String? transactionId;
    String? accountId;
    String? categoryId;
    String? type;

    if (arguments != null) {
      transactionId = arguments['transactionId'] as String?;
      accountId = arguments['accountId'] as String?;
      categoryId = arguments['categoryId'] as String?;
      type = arguments['type'] as String?;
    } else {
      final uri = Uri.parse(routeName);
      transactionId = uri.queryParameters['transactionId'];
      accountId = uri.queryParameters['accountId'];
      categoryId = uri.queryParameters['categoryId'];
      type = uri.queryParameters['type'];
    }

    switch (routeName) {
      case TransactionRoutes.home:
        return const TransactionsPage();
      case TransactionRoutes.details:
        return TransactionDetailsPage(transactionId: transactionId ?? '');
      case TransactionRoutes.add:
        return AddTransactionPage(
          presetAccountId: accountId,
          presetCategoryId: categoryId,
          presetType: type,
        );
      case TransactionRoutes.edit:
        return EditTransactionPage(transactionId: transactionId ?? '');
      case TransactionRoutes.recurring:
        return const RecurringTransactionsPage();
      default:
        return const TransactionsPage();
    }
  }

  /// Get the page route for a transactions route
  static PageRoute getPageRoute(String route, {Map<String, dynamic>? arguments}) {
    return MaterialPageRoute(
      builder: (context) => buildRoute(context, RouteSettings(name: route, arguments: arguments)),
      settings: RouteSettings(name: route, arguments: arguments),
    );
  }

  /// Get the route table for GoRouter
  static Map<String, WidgetBuilder> get routeTable {
    return {
      TransactionRoutes.home: (context) => const TransactionsPage(),
      TransactionRoutes.details: (context) => const TransactionDetailsPage(),
      TransactionRoutes.add: (context) => const AddTransactionPage(),
      TransactionRoutes.edit: (context) => const EditTransactionPage(),
      TransactionRoutes.recurring: (context) => const RecurringTransactionsPage(),
    };
  }
}

/// Extension for navigation context
extension TransactionRouteContext on BuildContext {
  /// Navigate to transactions home
  void goToTransactionsHome() {
    Navigator.pushReplacementNamed(this, TransactionRoutes.home);
  }

  /// Navigate to transaction details
  void goToTransactionDetails(String transactionId) {
    Navigator.pushNamed(
      this,
      TransactionRoutes.details,
      arguments: {'transactionId': transactionId},
    );
  }

  /// Navigate to add transaction
  void goToAddTransaction({
    String? accountId,
    String? categoryId,
    String? type,
  }) {
    Navigator.pushNamed(
      this,
      TransactionRoutes.add,
      arguments: {
        'accountId': accountId,
        'categoryId': categoryId,
        'type': type,
      },
    );
  }

  /// Navigate to edit transaction
  void goToEditTransaction(String transactionId) {
    Navigator.pushNamed(
      this,
      TransactionRoutes.edit,
      arguments: {'transactionId': transactionId},
    );
  }

  /// Navigate to recurring transactions
  void goToRecurringTransactions() {
    Navigator.pushNamed(this, TransactionRoutes.recurring);
  }

  /// Pop back to transactions home
  void popToTransactionsHome() {
    Navigator.popUntil(this, (route) => route.settings.name == TransactionRoutes.home);
  }
}
