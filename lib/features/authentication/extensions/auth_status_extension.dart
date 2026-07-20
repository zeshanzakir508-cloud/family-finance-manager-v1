import '../enums/auth_status.dart';

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

  /// Returns the display name for the status.
  String get displayName {
    switch (this) {
      case AuthStatus.initial:
        return 'Initializing...';
      case AuthStatus.unauthenticated:
        return 'Not Authenticated';
      case AuthStatus.authenticated:
        return 'Authenticated';
      case AuthStatus.unverified:
        return 'Email Not Verified';
      case AuthStatus.loading:
        return 'Loading...';
      case AuthStatus.failed:
        return 'Authentication Failed';
      case AuthStatus.blocked:
        return 'Account Blocked';
      case AuthStatus.disabled:
        return 'Account Disabled';
      case AuthStatus.sessionExpired:
        return 'Session Expired';
    }
  }

  /// Returns the appropriate icon name for the status.
  String get iconName {
    switch (this) {
      case AuthStatus.initial:
        return 'hourglass_empty';
      case AuthStatus.unauthenticated:
        return 'person_outline';
      case AuthStatus.authenticated:
        return 'check_circle';
      case AuthStatus.unverified:
        return 'email_outline';
      case AuthStatus.loading:
        return 'refresh';
      case AuthStatus.failed:
        return 'error_outline';
      case AuthStatus.blocked:
        return 'block';
      case AuthStatus.disabled:
        return 'do_not_disturb';
      case AuthStatus.sessionExpired:
        return 'timer_off';
    }
  }

  /// Returns the appropriate color for the status.
  /// Note: Replace with AppColors when integrating.
  String get colorHex {
    switch (this) {
      case AuthStatus.initial:
        return '#FFA726'; // Orange
      case AuthStatus.unauthenticated:
        return '#78909C'; // Grey
      case AuthStatus.authenticated:
        return '#43A047'; // Green
      case AuthStatus.unverified:
        return '#FFC107'; // Amber
      case AuthStatus.loading:
        return '#42A5F5'; // Blue
      case AuthStatus.failed:
        return '#EF5350'; // Red
      case AuthStatus.blocked:
        return '#E53935'; // Dark Red
      case AuthStatus.disabled:
        return '#B71C1C'; // Deep Red
      case AuthStatus.sessionExpired:
        return '#FF6F00'; // Dark Amber
    }
  }

  /// Returns true if the status requires immediate attention.
  bool get requiresImmediateAction {
    return this == AuthStatus.blocked ||
        this == AuthStatus.disabled ||
        this == AuthStatus.sessionExpired;
  }

  /// Returns true if the status is terminal.
  bool get isTerminal {
    return this == AuthStatus.authenticated ||
        this == AuthStatus.unverified ||
        this == AuthStatus.blocked ||
        this == AuthStatus.disabled ||
        this == AuthStatus.unauthenticated;
  }

  /// Returns true if the status is transient.
  bool get isTransient {
    return this == AuthStatus.initial ||
        this == AuthStatus.loading ||
        this == AuthStatus.failed ||
        this == AuthStatus.sessionExpired;
  }
}
