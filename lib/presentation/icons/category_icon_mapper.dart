// lib/presentation/icons/category_icon_mapper.dart

import '../../domain/transaction/transaction_category.dart';
import 'category_icon.dart';

/// A mapper that associates each [TransactionCategory] with its corresponding
/// [CategoryIcon] for semantic icon representation throughout the application.
///
/// This class serves as the single source of truth for category-icon
/// associations, using a platform-agnostic [CategoryIcon] enum that can be
/// later mapped to platform-specific [IconData] by a separate mapper.
///
/// Example:
/// ```dart
/// final icon = CategoryIconMapper.of(TransactionCategory.food);
/// // Returns CategoryIcon.food
/// ```
abstract final class CategoryIconMapper {
  /// The complete mapping of transaction categories to their assigned icons.
  ///
  /// This map defines the canonical relationship between each category and its
  /// semantic icon representation. All categories should be included to ensure
  /// consistent iconography throughout the app.
  static const Map<TransactionCategory, CategoryIcon> _mappings = {
    // Food & Dining
    TransactionCategory.food: CategoryIcon.food,
    TransactionCategory.groceries: CategoryIcon.groceries,
    TransactionCategory.dining: CategoryIcon.dining,
    TransactionCategory.coffee: CategoryIcon.coffee,
    TransactionCategory.alcohol: CategoryIcon.alcohol,

    // Transportation
    TransactionCategory.transport: CategoryIcon.transport,
    TransactionCategory.car: CategoryIcon.car,
    TransactionCategory.bike: CategoryIcon.bike,
    TransactionCategory.public: CategoryIcon.public,
    TransactionCategory.parking: CategoryIcon.parking,
    TransactionCategory.toll: CategoryIcon.toll,
    TransactionCategory.fuel: CategoryIcon.fuel,
    TransactionCategory.charging: CategoryIcon.charging,

    // Housing & Utilities
    TransactionCategory.housing: CategoryIcon.housing,
    TransactionCategory.rent: CategoryIcon.rent,
    TransactionCategory.mortgage: CategoryIcon.mortgage,
    TransactionCategory.property: CategoryIcon.property,
    TransactionCategory.maintenance: CategoryIcon.maintenance,
    TransactionCategory.repair: CategoryIcon.repair,
    TransactionCategory.cleaning: CategoryIcon.cleaning,
    TransactionCategory.garden: CategoryIcon.garden,
    TransactionCategory.utilities: CategoryIcon.utilities,
    TransactionCategory.phone: CategoryIcon.phone,
    TransactionCategory.internet: CategoryIcon.internet,
    TransactionCategory.tv: CategoryIcon.tv,
    TransactionCategory.bills: CategoryIcon.bills,

    // Healthcare
    TransactionCategory.healthcare: CategoryIcon.healthcare,
    TransactionCategory.pharmacy: CategoryIcon.pharmacy,
    TransactionCategory.doctor: CategoryIcon.doctor,
    TransactionCategory.dentist: CategoryIcon.dentist,
    TransactionCategory.vision: CategoryIcon.vision,
    TransactionCategory.therapy: CategoryIcon.therapy,

    // Education
    TransactionCategory.education: CategoryIcon.education,
    TransactionCategory.books: CategoryIcon.books,
    TransactionCategory.courses: CategoryIcon.courses,
    TransactionCategory.tuition: CategoryIcon.tuition,
    TransactionCategory.workshop: CategoryIcon.workshop,

    // Entertainment & Leisure
    TransactionCategory.entertainment: CategoryIcon.entertainment,
    TransactionCategory.music: CategoryIcon.music,
    TransactionCategory.gaming: CategoryIcon.gaming,
    TransactionCategory.sports: CategoryIcon.sports,
    TransactionCategory.hobbies: CategoryIcon.hobbies,
    TransactionCategory.travel: CategoryIcon.travel,
    TransactionCategory.vacation: CategoryIcon.vacation,
    TransactionCategory.hotel: CategoryIcon.hotel,
    TransactionCategory.flights: CategoryIcon.flights,

    // Shopping
    TransactionCategory.shopping: CategoryIcon.shopping,
    TransactionCategory.clothing: CategoryIcon.clothing,
    TransactionCategory.electronics: CategoryIcon.electronics,
    TransactionCategory.furniture: CategoryIcon.furniture,
    TransactionCategory.toys: CategoryIcon.toys,

    // Insurance & Financial
    TransactionCategory.insurance: CategoryIcon.insurance,
    TransactionCategory.savings: CategoryIcon.savings,
    TransactionCategory.investment: CategoryIcon.investment,
    TransactionCategory.interest: CategoryIcon.interest,
    TransactionCategory.dividend: CategoryIcon.dividend,
    TransactionCategory.loan: CategoryIcon.loan,
    TransactionCategory.debt: CategoryIcon.debt,
    TransactionCategory.tax: CategoryIcon.tax,
    TransactionCategory.fees: CategoryIcon.fees,
    TransactionCategory.interest_paid: CategoryIcon.interestPaid,

    // Income
    TransactionCategory.income: CategoryIcon.income,
    TransactionCategory.salary: CategoryIcon.salary,
    TransactionCategory.freelance: CategoryIcon.freelance,
    TransactionCategory.rental: CategoryIcon.rental,
    TransactionCategory.gift: CategoryIcon.gift,

    // Lifestyle
    TransactionCategory.pet: CategoryIcon.pet,
    TransactionCategory.kids: CategoryIcon.kids,
    TransactionCategory.maternity: CategoryIcon.maternity,
    TransactionCategory.elderly: CategoryIcon.elderly,

    // Subscriptions & Services
    TransactionCategory.subscription: CategoryIcon.subscription,
    TransactionCategory.membership: CategoryIcon.membership,
    TransactionCategory.software: CategoryIcon.software,
    TransactionCategory.hardware: CategoryIcon.hardware,
    TransactionCategory.office: CategoryIcon.office,

    // Charity & Donations
    TransactionCategory.charity: CategoryIcon.charity,
    TransactionCategory.donation: CategoryIcon.donation,

    // Default
    TransactionCategory.other: CategoryIcon.other,
    TransactionCategory.uncategorized: CategoryIcon.uncategorized,
  };

  /// Returns the [CategoryIcon] associated with the given [category].
  ///
  /// If the category is not found in the mapper, returns [CategoryIcon.uncategorized]
  /// as a safe default to ensure the UI always has an icon to display.
  ///
  /// Parameters:
  ///   - [category]: The transaction category to look up.
  ///
  /// Returns:
  ///   The corresponding [CategoryIcon] or [CategoryIcon.uncategorized] as fallback.
  ///
  /// Example:
  /// ```dart
  /// final icon = CategoryIconMapper.of(TransactionCategory.food);
  /// // Returns CategoryIcon.food
  /// ```
  static CategoryIcon of(TransactionCategory category) {
    return _mappings[category] ?? CategoryIcon.uncategorized;
  }
}
