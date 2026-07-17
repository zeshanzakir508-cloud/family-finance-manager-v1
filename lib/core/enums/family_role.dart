/// Defines a member's role within a family.
///
/// These permissions apply only inside a specific family.
enum FamilyRole {
  /// Family owner with full permissions.
  owner,

  /// Can help manage the family.
  moderator,

  /// Regular family member.
  member,
}

/// Convenience extensions for [FamilyRole].
extension FamilyRoleExtension on FamilyRole {
  /// String representation used for storage and serialization.
  String get value => name;

  bool get isOwner => this == FamilyRole.owner;

  bool get isModerator => this == FamilyRole.moderator;

  bool get isMember => this == FamilyRole.member;

  static FamilyRole fromValue(String value) {
    return FamilyRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => FamilyRole.member,
    );
  }
}
