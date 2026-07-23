import 'package:flutter/material.dart';
import '../views/pages/categories_page.dart';
import '../views/pages/add_category_page.dart';
import '../views/pages/edit_category_page.dart';

/// Route names for the Categories feature
class CategoryRoutes {
  static const String home = '/categories';
  static const String add = '/categories/add';
  static const String edit = '/categories/edit';

  /// Get all routes
  static List<String> get allRoutes => [
        home,
        add,
        edit,
      ];

  /// Check if a route is a categories route
  static bool isCategoriesRoute(String route) {
    return route.startsWith('/categories');
  }

  /// Get the route for editing a category
  static String getEditCategoryRoute(String categoryId) {
    return '$edit?categoryId=$categoryId';
  }
}

/// Route configuration for categories feature
class CategoryRouteConfig {
  /// Build a route for categories
  static Widget buildRoute(BuildContext context, RouteSettings settings) {
    final routeName = settings.name ?? '';
    final arguments = settings.arguments as Map<String, dynamic>?;

    // Extract categoryId from query parameters or arguments
    String? categoryId;
    if (arguments != null && arguments.containsKey('categoryId')) {
      categoryId = arguments['categoryId'] as String?;
    } else {
      // Parse from route path
      final uri = Uri.parse(routeName);
      categoryId = uri.queryParameters['categoryId'];
    }

    switch (routeName) {
      case CategoryRoutes.home:
        return const CategoriesPage();
      case CategoryRoutes.add:
        return const AddCategoryPage();
      case CategoryRoutes.edit:
        return EditCategoryPage(categoryId: categoryId ?? '');
      default:
        return const CategoriesPage();
    }
  }

  /// Get the page route for a categories route
  static PageRoute getPageRoute(String route, {Map<String, dynamic>? arguments}) {
    return MaterialPageRoute(
      builder: (context) => buildRoute(context, RouteSettings(name: route, arguments: arguments)),
      settings: RouteSettings(name: route, arguments: arguments),
    );
  }

  /// Get the route table for GoRouter
  static Map<String, WidgetBuilder> get routeTable {
    return {
      CategoryRoutes.home: (context) => const CategoriesPage(),
      CategoryRoutes.add: (context) => const AddCategoryPage(),
      CategoryRoutes.edit: (context) => const EditCategoryPage(),
    };
  }
}

/// Extension for navigation context
extension CategoryRouteContext on BuildContext {
  /// Navigate to categories home
  void goToCategoriesHome() {
    Navigator.pushReplacementNamed(this, CategoryRoutes.home);
  }

  /// Navigate to add category
  void goToAddCategory() {
    Navigator.pushNamed(this, CategoryRoutes.add);
  }

  /// Navigate to edit category
  void goToEditCategory(String categoryId) {
    Navigator.pushNamed(
      this,
      CategoryRoutes.edit,
      arguments: {'categoryId': categoryId},
    );
  }

  /// Pop back to categories home
  void popToCategoriesHome() {
    Navigator.popUntil(this, (route) => route.settings.name == CategoryRoutes.home);
  }
}
