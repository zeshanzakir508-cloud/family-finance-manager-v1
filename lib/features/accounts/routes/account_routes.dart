import 'package:flutter/material.dart';
import '../views/pages/accounts_page.dart';
import '../views/pages/account_details_page.dart';
import '../views/pages/add_account_page.dart';
import '../views/pages/edit_account_page.dart';
import '../views/pages/transfer_between_accounts_page.dart';

/// Route names for the Accounts feature
class AccountRoutes {
  static const String home = '/accounts';
  static const String details = '/accounts/details';
  static const String add = '/accounts/add';
  static const String edit = '/accounts/edit';
  static const String transfer = '/accounts/transfer';

  /// Get all routes
  static List<String> get allRoutes => [
        home,
        details,
        add,
        edit,
        transfer,
      ];

  /// Check if a route is an accounts route
  static bool isAccountsRoute(String route) {
    return route.startsWith('/accounts');
  }

  /// Get the route for account details
  static String getAccountDetailsRoute(String accountId) {
    return '$details?accountId=$accountId';
  }

  /// Get the route for editing an account
  static String getEditAccountRoute(String accountId) {
    return '$edit?accountId=$accountId';
  }

  /// Get the route for transfer
  static String getTransferRoute({String? fromAccountId, String? toAccountId}) {
    var route = transfer;
    final params = <String>[];
    if (fromAccountId != null) {
      params.add('from=$fromAccountId');
    }
    if (toAccountId != null) {
      params.add('to=$toAccountId');
    }
    if (params.isNotEmpty) {
      route = '$transfer?${params.join('&')}';
    }
    return route;
  }
}

/// Route configuration for accounts feature
class AccountRouteConfig {
  /// Build a route for accounts
  static Widget buildRoute(BuildContext context, RouteSettings settings) {
    final routeName = settings.name ?? '';
    final arguments = settings.arguments as Map<String, dynamic>?;

    // Extract accountId from query parameters or arguments
    String? accountId;
    if (arguments != null && arguments.containsKey('accountId')) {
      accountId = arguments['accountId'] as String?;
    } else {
      // Parse from route path
      final uri = Uri.parse(routeName);
      accountId = uri.queryParameters['accountId'];
    }

    // Extract transfer parameters
    String? fromAccountId;
    String? toAccountId;
    if (arguments != null) {
      if (arguments.containsKey('fromAccountId')) {
        fromAccountId = arguments['fromAccountId'] as String?;
      }
      if (arguments.containsKey('toAccountId')) {
        toAccountId = arguments['toAccountId'] as String?;
      }
    } else {
      final uri = Uri.parse(routeName);
      fromAccountId = uri.queryParameters['from'];
      toAccountId = uri.queryParameters['to'];
    }

    switch (routeName) {
      case AccountRoutes.home:
        return const AccountsPage();
      case AccountRoutes.details:
        return AccountDetailsPage(accountId: accountId ?? '');
      case AccountRoutes.add:
        return const AddAccountPage();
      case AccountRoutes.edit:
        return EditAccountPage(accountId: accountId ?? '');
      case AccountRoutes.transfer:
        return TransferBetweenAccountsPage(
          fromAccountId: fromAccountId,
          toAccountId: toAccountId,
        );
      default:
        return const AccountsPage();
    }
  }

  /// Get the page route for an accounts route
  static PageRoute getPageRoute(String route, {Map<String, dynamic>? arguments}) {
    return MaterialPageRoute(
      builder: (context) => buildRoute(context, RouteSettings(name: route, arguments: arguments)),
      settings: RouteSettings(name: route, arguments: arguments),
    );
  }

  /// Get the route table for GoRouter
  static Map<String, WidgetBuilder> get routeTable {
    return {
      AccountRoutes.home: (context) => const AccountsPage(),
      AccountRoutes.details: (context) => const AccountDetailsPage(),
      AccountRoutes.add: (context) => const AddAccountPage(),
      AccountRoutes.edit: (context) => const EditAccountPage(),
      AccountRoutes.transfer: (context) => const TransferBetweenAccountsPage(),
    };
  }
}

/// Extension for navigation context
extension AccountRouteContext on BuildContext {
  /// Navigate to accounts home
  void goToAccountsHome() {
    Navigator.pushReplacementNamed(this, AccountRoutes.home);
  }

  /// Navigate to account details
  void goToAccountDetails(String accountId) {
    Navigator.pushNamed(
      this,
      AccountRoutes.details,
      arguments: {'accountId': accountId},
    );
  }

  /// Navigate to add account
  void goToAddAccount() {
    Navigator.pushNamed(this, AccountRoutes.add);
  }

  /// Navigate to edit account
  void goToEditAccount(String accountId) {
    Navigator.pushNamed(
      this,
      AccountRoutes.edit,
      arguments: {'accountId': accountId},
    );
  }

  /// Navigate to transfer
  void goToTransfer({String? fromAccountId, String? toAccountId}) {
    Navigator.pushNamed(
      this,
      AccountRoutes.transfer,
      arguments: {
        'fromAccountId': fromAccountId,
        'toAccountId': toAccountId,
      },
    );
  }

  /// Pop back to accounts home
  void popToAccountsHome() {
    Navigator.popUntil(this, (route) => route.settings.name == AccountRoutes.home);
  }
}
