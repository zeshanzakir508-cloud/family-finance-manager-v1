// lib/presentation/icons/category_icon.dart

/// An enumeration of all icons used throughout the application.
///
/// This enum serves as an abstraction layer between the presentation logic
/// and the underlying icon implementation (Material, Cupertino, etc.).
/// It allows the app to switch icon packages without changing business logic.
///
/// Each entry represents a semantic icon that can be mapped to platform-specific
/// [IconData] by a separate mapper.
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
