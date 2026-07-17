/// Defines application-level roles.
///
/// These roles control access to developer and moderation features
/// across the entire application.
///
/// Note:
/// Family-specific permissions are handled separately by FamilyRole
/// (to be added later if needed).
enum AppRole {
  /// Regular application user.
  user,

  /// Can moderate application content and users.
  moderator,

  /// Full access to developer features and management tools.
  developer,
}

/// Convenience extensions for [AppRole].
extension AppRoleExtension on AppRole {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Returns true if the role is User.
  bool get isUser => this == AppRole.user;

  /// Returns true if the role is Moderator.
  bool get isModerator => this == AppRole.moderator;

  /// Returns true if the role is Developer.
  bool get isDeveloper => this == AppRole.developer;

  /// Creates an [AppRole] from a stored string value.
  static AppRole fromValue(String value) {
    return AppRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => AppRole.user,
    );
  }
}
