// lib/presentation/colors/plan_highlight_color.dart

/// Enum representing highlight colors for subscription plans.
enum PlanHighlightColor {
  /// Red highlight.
  red,

  /// Pink highlight.
  pink,

  /// Purple highlight.
  purple,

  /// Blue highlight.
  blue,

  /// Cyan highlight.
  cyan,

  /// Green highlight.
  green,

  /// Yellow highlight.
  yellow,

  /// Orange highlight.
  orange,

  /// Gold highlight (premium feel).
  gold,

  /// None/no highlight.
  none,
}

/// Extension methods for [PlanHighlightColor].
extension PlanHighlightColorExtension on PlanHighlightColor {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [PlanHighlightColor] from a stored string value.
  static PlanHighlightColor fromValue(String value) {
    return PlanHighlightColor.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PlanHighlightColor.none,
    );
  }

  /// Returns whether this is a highlight color (not none).
  bool get hasColor => this != PlanHighlightColor.none;

  /// Returns whether this is gold.
  bool get isGold => this == PlanHighlightColor.gold;
}
