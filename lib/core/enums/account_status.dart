/// Defines the current status of a user's account.
///
/// This status determines whether the user is allowed to access
/// the application.
enum AccountStatus {
  /// Account is active and fully usable.
  active,

  /// Account is temporarily suspended.
  suspended,

  /// Account is blocked by the developer.
  blocked,
}

/// Convenience extensions for [AccountStatus].
extension AccountStatusExtension on AccountStatus {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Returns true if the account is active.
  bool get isActive => this == AccountStatus.active;

  /// Returns true if the account is suspended.
  bool get isSuspended => this == AccountStatus.suspended;

  /// Returns true if the account is blocked.
  bool get isBlocked => this == AccountStatus.blocked;

  /// Creates an [AccountStatus] from a stored string value.
  static AccountStatus fromValue(String value) {
    return AccountStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => AccountStatus.active,
    );
  }
}
