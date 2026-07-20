/// Verification status of user identity.
///
/// Represents the current verification state of email, phone, or identity.
enum VerificationStatus {
  /// Verification not started
  notStarted,

  /// Verification in progress
  pending,

  /// Verification completed successfully
  verified,

  /// Verification failed
  failed,

  /// Verification expired
  expired,

  /// Verification skipped
  skipped,

  /// Verification resent
  resent,
}

/// Extension methods for [VerificationStatus].
extension VerificationStatusExtension on VerificationStatus {
  /// Returns true if the user is verified.
  bool get isVerified {
    return this == VerificationStatus.verified;
  }

  /// Returns true if verification is in progress.
  bool get isPending {
    return this == VerificationStatus.pending;
  }

  /// Returns true if verification can be retried.
  bool get canRetry {
    return this == VerificationStatus.failed ||
        this == VerificationStatus.expired;
  }

  /// Returns true if verification can be resent.
  bool get canResend {
    return this == VerificationStatus.notStarted ||
        this == VerificationStatus.failed ||
        this == VerificationStatus.expired;
  }

  /// Returns the display label for the status.
  String get displayLabel {
    switch (this) {
      case VerificationStatus.notStarted:
        return 'Not Verified';
      case VerificationStatus.pending:
        return 'Verifying...';
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.failed:
        return 'Verification Failed';
      case VerificationStatus.expired:
        return 'Verification Expired';
      case VerificationStatus.skipped:
        return 'Skipped';
      case VerificationStatus.resent:
        return 'Resent';
    }
  }

  /// Returns true if this is a terminal state.
  bool get isTerminal {
    return this == VerificationStatus.verified ||
        this == VerificationStatus.failed ||
        this == VerificationStatus.expired;
  }
}
