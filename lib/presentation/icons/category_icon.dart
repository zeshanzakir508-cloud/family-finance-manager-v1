// lib/presentation/icons/category_icon.dart

/// An enumeration of all category icons used throughout the application.
///
/// This enum serves as the semantic layer for category icons, providing
/// type-safe references that can be mapped to platform-specific icons.
///
/// Example:
/// ```dart
/// final icon = CategoryIcon.food;
/// ```
enum CategoryIcon {
  // Food & Dining
  food,
  groceries,
  dining,
  coffee,
  alcohol,

  // Transportation
  transport,
  car,
  bike,
  public,
  parking,
  toll,
  fuel,
  charging,

  // Housing & Utilities
  housing,
  rent,
  mortgage,
  property,
  maintenance,
  repair,
  cleaning,
  garden,
  utilities,
  phone,
  internet,
  tv,
  bills,

  // Healthcare
  healthcare,
  pharmacy,
  doctor,
  dentist,
  vision,
  therapy,

  // Education
  education,
  books,
  courses,
  tuition,
  workshop,

  // Entertainment & Leisure
  entertainment,
  music,
  gaming,
  sports,
  hobbies,
  travel,
  vacation,
  hotel,
  flights,

  // Shopping
  shopping,
  clothing,
  electronics,
  furniture,
  toys,

  // Insurance & Financial
  insurance,
  savings,
  investment,
  interest,
  dividend,
  loan,
  debt,
  tax,
  fees,
  interestPaid,

  // Income
  income,
  salary,
  freelance,
  rental,
  gift,

  // Lifestyle
  pet,
  kids,
  maternity,
  elderly,

  // Subscriptions & Services
  subscription,
  membership,
  software,
  hardware,
  office,

  // Charity & Donations
  charity,
  donation,

  // Default
  other,
  uncategorized,
}
