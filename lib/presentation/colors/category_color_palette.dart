// lib/presentation/colors/category_color_palette.dart

import 'transaction_category.dart';
import 'category_color.dart';

/// A palette that maps each [TransactionCategory] to its corresponding [CategoryColor].
///
/// This class serves as the single source of truth for category-color associations
/// across the application. It provides a simple, immutable mapping that can be
/// reused anywhere color information is needed.
///
/// Example:
/// ```dart
/// final color = CategoryColorPalette.of(TransactionCategory.food);
/// ```
abstract final class CategoryColorPalette {
  /// The complete mapping of transaction categories to their assigned colors.
  ///
  /// This map defines the canonical relationship between each category and its
  /// visual representation. All categories should be included to ensure
  /// consistent theming throughout the app.
  static const Map<TransactionCategory, CategoryColor> _mappings = {
    // Essential categories
    TransactionCategory.food: CategoryColor.red,
    TransactionCategory.transport: CategoryColor.blue,
    TransactionCategory.housing: CategoryColor.green,
    TransactionCategory.utilities: CategoryColor.cyan,
    TransactionCategory.healthcare: CategoryColor.pink,
    TransactionCategory.education: CategoryColor.purple,
    TransactionCategory.entertainment: CategoryColor.orange,
    TransactionCategory.shopping: CategoryColor.yellow,
    TransactionCategory.bills: CategoryColor.indigo,
    TransactionCategory.insurance: CategoryColor.teal,
    TransactionCategory.savings: CategoryColor.green,
    TransactionCategory.investment: CategoryColor.gold,
    TransactionCategory.income: CategoryColor.green,
    TransactionCategory.salary: CategoryColor.green,
    TransactionCategory.freelance: CategoryColor.purple,
    TransactionCategory.rental: CategoryColor.indigo,
    TransactionCategory.interest: CategoryColor.cyan,
    TransactionCategory.dividend: CategoryColor.gold,
    TransactionCategory.gift: CategoryColor.pink,
    
    // Additional common categories
    TransactionCategory.groceries: CategoryColor.red,
    TransactionCategory.dining: CategoryColor.orange,
    TransactionCategory.coffee: CategoryColor.brown,
    TransactionCategory.alcohol: CategoryColor.red,
    TransactionCategory.clothing: CategoryColor.purple,
    TransactionCategory.electronics: CategoryColor.blue,
    TransactionCategory.furniture: CategoryColor.brown,
    TransactionCategory.hobbies: CategoryColor.pink,
    TransactionCategory.sports: CategoryColor.orange,
    TransactionCategory.travel: CategoryColor.cyan,
    TransactionCategory.vacation: CategoryColor.cyan,
    TransactionCategory.hotel: CategoryColor.blue,
    TransactionCategory.flights: CategoryColor.indigo,
    TransactionCategory.rent: CategoryColor.blue,
    TransactionCategory.mortgage: CategoryColor.green,
    TransactionCategory.property: CategoryColor.green,
    TransactionCategory.maintenance: CategoryColor.gray,
    TransactionCategory.repair: CategoryColor.gray,
    TransactionCategory.cleaning: CategoryColor.cyan,
    TransactionCategory.garden: CategoryColor.green,
    TransactionCategory.pet: CategoryColor.orange,
    TransactionCategory.pharmacy: CategoryColor.pink,
    TransactionCategory.doctor: CategoryColor.red,
    TransactionCategory.dentist: CategoryColor.blue,
    TransactionCategory.vision: CategoryColor.purple,
    TransactionCategory.therapy: CategoryColor.pink,
    TransactionCategory.books: CategoryColor.purple,
    TransactionCategory.courses: CategoryColor.indigo,
    TransactionCategory.tuition: CategoryColor.blue,
    TransactionCategory.workshop: CategoryColor.orange,
    TransactionCategory.charity: CategoryColor.red,
    TransactionCategory.donation: CategoryColor.pink,
    TransactionCategory.tax: CategoryColor.gray,
    TransactionCategory.fees: CategoryColor.gray,
    TransactionCategory.interest_paid: CategoryColor.red,
    TransactionCategory.loan: CategoryColor.indigo,
    TransactionCategory.debt: CategoryColor.red,
    TransactionCategory.subscription: CategoryColor.purple,
    TransactionCategory.membership: CategoryColor.blue,
    TransactionCategory.software: CategoryColor.cyan,
    TransactionCategory.hardware: CategoryColor.gray,
    TransactionCategory.office: CategoryColor.brown,
    TransactionCategory.phone: CategoryColor.blue,
    TransactionCategory.internet: CategoryColor.cyan,
    TransactionCategory.tv: CategoryColor.purple,
    TransactionCategory.music: CategoryColor.pink,
    TransactionCategory.gaming: CategoryColor.orange,
    TransactionCategory.toys: CategoryColor.yellow,
    TransactionCategory.kids: CategoryColor.green,
    TransactionCategory.maternity: CategoryColor.pink,
    TransactionCategory.elderly: CategoryColor.gray,
    TransactionCategory.car: CategoryColor.blue,
    TransactionCategory.bike: CategoryColor.orange,
    TransactionCategory.public: CategoryColor.green,
    TransactionCategory.parking: CategoryColor.gray,
    TransactionCategory.toll: CategoryColor.brown,
    TransactionCategory.fuel: CategoryColor.orange,
    TransactionCategory.charging: CategoryColor.green,
    
    // Default for any uncategorized transactions
    TransactionCategory.other: CategoryColor.gray,
    TransactionCategory.uncategorized: CategoryColor.gray,
  };

  /// Returns the [CategoryColor] associated with the given [category].
  ///
  /// If the category is not found in the palette, returns [CategoryColor.gray]
  /// as a safe default to ensure the UI always has a color to display.
  ///
  /// Parameters:
  ///   - [category]: The transaction category to look up.
  ///
  /// Returns:
  ///   The corresponding [CategoryColor] or [CategoryColor.gray] as fallback.
  ///
  /// Example:
  /// ```dart
  /// final color = CategoryColorPalette.of(TransactionCategory.food);
  /// // Returns CategoryColor.red
  /// ```
  static CategoryColor of(TransactionCategory category) {
    return _mappings[category] ?? CategoryColor.gray;
  }
}
