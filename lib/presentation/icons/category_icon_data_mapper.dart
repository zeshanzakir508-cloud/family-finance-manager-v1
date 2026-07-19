// lib/presentation/icons/category_icon_data_mapper.dart

import 'package:flutter/material.dart';

import 'category_icon.dart';

/// A mapper that converts [CategoryIcon] enum values to Material [IconData].
///
/// This class acts as the bridge between the semantic category icon layer
/// and the underlying icon implementation. Currently uses Material Icons,
/// but can be easily swapped to support other icon packages.
///
/// Example:
/// ```dart
/// final iconData = CategoryIconDataMapper.of(CategoryIcon.food);
/// // Returns Icons.restaurant
/// ```
abstract final class CategoryIconDataMapper {
  /// The complete mapping of [CategoryIcon] to Material [IconData].
  ///
  /// This map defines how semantic category icons are translated to Material icons.
  /// Changes to this map affect the entire app's category iconography.
  static const Map<CategoryIcon, IconData> _mappings = {
    // Food & Dining
    CategoryIcon.food: Icons.restaurant,
    CategoryIcon.groceries: Icons.shopping_cart,
    CategoryIcon.dining: Icons.dining,
    CategoryIcon.coffee: Icons.coffee,
    CategoryIcon.alcohol: Icons.local_bar,

    // Transportation
    CategoryIcon.transport: Icons.directions_car,
    CategoryIcon.car: Icons.car_repair,
    CategoryIcon.bike: Icons.directions_bike,
    CategoryIcon.public: Icons.directions_bus,
    CategoryIcon.parking: Icons.local_parking,
    CategoryIcon.toll: Icons.toll,
    CategoryIcon.fuel: Icons.local_gas_station,
    CategoryIcon.charging: Icons.ev_station,

    // Housing & Utilities
    CategoryIcon.housing: Icons.home,
    CategoryIcon.rent: Icons.attach_money,
    CategoryIcon.mortgage: Icons.home_work,
    CategoryIcon.property: Icons.house,
    CategoryIcon.maintenance: Icons.build,
    CategoryIcon.repair: Icons.handyman,
    CategoryIcon.cleaning: Icons.cleaning_services,
    CategoryIcon.garden: Icons.grass,
    CategoryIcon.utilities: Icons.bolt,
    CategoryIcon.phone: Icons.phone_android,
    CategoryIcon.internet: Icons.wifi,
    CategoryIcon.tv: Icons.tv,
    CategoryIcon.bills: Icons.receipt_long,

    // Healthcare
    CategoryIcon.healthcare: Icons.health_and_safety,
    CategoryIcon.pharmacy: Icons.medication,
    CategoryIcon.doctor: Icons.medical_services,
    CategoryIcon.dentist: Icons.dentistry,
    CategoryIcon.vision: Icons.visibility,
    CategoryIcon.therapy: Icons.psychology,

    // Education
    CategoryIcon.education: Icons.school,
    CategoryIcon.books: Icons.library_books,
    CategoryIcon.courses: Icons.cast_for_education,
    CategoryIcon.tuition: Icons.account_balance,
    CategoryIcon.workshop: Icons.workspace_premium,

    // Entertainment & Leisure
    CategoryIcon.entertainment: Icons.movie,
    CategoryIcon.music: Icons.music_note,
    CategoryIcon.gaming: Icons.sports_esports,
    CategoryIcon.sports: Icons.sports,
    CategoryIcon.hobbies: Icons.brush,
    CategoryIcon.travel: Icons.flight_takeoff,
    CategoryIcon.vacation: Icons.beach_access,
    CategoryIcon.hotel: Icons.hotel,
    CategoryIcon.flights: Icons.flight,

    // Shopping
    CategoryIcon.shopping: Icons.shopping_bag,
    CategoryIcon.clothing: Icons.checkroom,
    CategoryIcon.electronics: Icons.electrical_services,
    CategoryIcon.furniture: Icons.chair,
    CategoryIcon.toys: Icons.toys,

    // Insurance & Financial
    CategoryIcon.insurance: Icons.insurance,
    CategoryIcon.savings: Icons.savings,
    CategoryIcon.investment: Icons.trending_up,
    CategoryIcon.interest: Icons.percent,
    CategoryIcon.dividend: Icons.pie_chart,
    CategoryIcon.loan: Icons.credit_card,
    CategoryIcon.debt: Icons.money_off,
    CategoryIcon.tax: Icons.request_page,
    CategoryIcon.fees: Icons.attach_money,
    CategoryIcon.interestPaid: Icons.currency_exchange,

    // Income
    CategoryIcon.income: Icons.arrow_downward,
    CategoryIcon.salary: Icons.work,
    CategoryIcon.freelance: Icons.computer,
    CategoryIcon.rental: Icons.apartment,
    CategoryIcon.gift: Icons.card_giftcard,

    // Lifestyle
    CategoryIcon.pet: Icons.pets,
    CategoryIcon.kids: Icons.child_care,
    CategoryIcon.maternity: Icons.family_restroom,
    CategoryIcon.elderly: Icons.elderly,

    // Subscriptions & Services
    CategoryIcon.subscription: Icons.subscriptions,
    CategoryIcon.membership: Icons.people,
    CategoryIcon.software: Icons.code,
    CategoryIcon.hardware: Icons.memory,
    CategoryIcon.office: Icons.business_center,

    // Charity & Donations
    CategoryIcon.charity: Icons.volunteer_activism,
    CategoryIcon.donation: Icons.favorite,

    // Default
    CategoryIcon.other: Icons.more_horiz,
    CategoryIcon.uncategorized: Icons.help_outline,
  };

  /// Returns the [IconData] associated with the given [CategoryIcon].
  ///
  /// If the icon is not found in the mapper, returns [Icons.help_outline]
  /// as a safe default to ensure the UI always has an icon to display.
  ///
  /// Parameters:
  ///   - [icon]: The semantic category icon to look up.
  ///
  /// Returns:
  ///   The corresponding [IconData] or [Icons.help_outline] as fallback.
  ///
  /// Example:
  /// ```dart
  /// final iconData = CategoryIconDataMapper.of(CategoryIcon.food);
  /// // Returns Icons.restaurant
  /// ```
  static IconData of(CategoryIcon icon) {
    return _mappings[icon] ?? Icons.help_outline;
  }
}
