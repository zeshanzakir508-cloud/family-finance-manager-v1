/// Session status of the user.
///
/// Represents the current state of the user session.
enum SessionStatus {
  /// Session is valid and active
  active,

  /// Session has expired
  expired,

  /// Session is about to expire (warning)
  expiring,

  /// Session has been manually refreshed
  refreshed,

  /// Session has been invalidated
  invalidated,

  /// Session is being renewed
  renewing,
}

/// Extension methods for [SessionStatus].
extension SessionStatusExtension on SessionStatus {
  /// Returns true if the session is valid.
  bool get isValid {
    return this == SessionStatus.active ||
        this == SessionStatus.refreshed;
  }

  /// Returns true if the session can be refreshed.
  bool get canRefresh {
    return this == SessionStatus.active ||
        this == SessionStatus.expiring;
  }

  /// Returns true if the session needs renewal.
  bool get needsRenewal {
    return this == SessionStatus.expiring ||
        this == SessionStatus.expired;
  }

  /// Returns true if the session is in progress.
  bool get isInProgress {
    return this == SessionStatus.renewing;
  }

  /// Returns the priority level for status handling.
  int get priority {
    switch (this) {
      case SessionStatus.active:
        return 0;
      case SessionStatus.refreshed:
        return 1;
      case SessionStatus.expiring:
        return 2;
      case SessionStatus.renewing:
        return 3;
      case SessionStatus.expired:
        return 4;
      case SessionStatus.invalidated:
        return 5;
    }
  }
}
