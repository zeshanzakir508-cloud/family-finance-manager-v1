/// Authentication status of the user.
///
/// Represents the current authentication state of the user
/// to control UI flow and navigation.
enum AuthStatus {
  /// Initial state, authentication not yet checked
  initial,

  /// User is not authenticated
  unauthenticated,

  /// User is authenticated
  authenticated,

  /// User is authenticated but email not verified
  unverified,

  /// Authentication is in progress
  loading,

  /// Authentication failed
  failed,

  /// Account is blocked
  blocked,

  /// Account is disabled
  disabled,

  /// Session has expired
  sessionExpired,
}

/// Extension methods for [AuthStatus].
extension AuthStatusExtension on AuthStatus {
  /// Returns true if the user can access protected content.
  bool get canAccessProtected {
    return this == AuthStatus.authenticated;
  }

  /// Returns true if the user needs to verify their email.
  bool get needsVerification {
    return this == AuthStatus.unverified;
  }

  /// Returns true if the user is blocked or disabled.
  bool get isBlocked {
    return this == AuthStatus.blocked ||
        this == AuthStatus.disabled;
  }

  /// Returns true if authentication is in progress.
  bool get isLoading {
    return this == AuthStatus.loading;
  }

  /// Returns true if the user is logged in (including unverified).
  bool get isLoggedIn {
    return this == AuthStatus.authenticated ||
        this == AuthStatus.unverified;
  }

  /// Returns true if the user is fully authenticated.
  bool get isFullyAuthenticated {
    return this == AuthStatus.authenticated;
  }

  /// Returns the priority level for status handling.
  int get priority {
    switch (this) {
      case AuthStatus.authenticated:
        return 0;
      case AuthStatus.unverified:
        return 1;
      case AuthStatus.loading:
        return 2;
      case AuthStatus.sessionExpired:
        return 3;
      case AuthStatus.initial:
        return 4;
      case AuthStatus.unauthenticated:
        return 5;
      case AuthStatus.failed:
        return 6;
      case AuthStatus.blocked:
        return 7;
      case AuthStatus.disabled:
        return 8;
    }
  }
}
