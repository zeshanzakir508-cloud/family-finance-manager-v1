// lib/core/enums/invitation_status.dart

/// Enum representing the status of a family invitation.
enum InvitationStatus {
  /// Invitation has been sent but not yet responded to.
  pending,

  /// Invitation has been accepted by the recipient.
  accepted,

  /// Invitation has been declined by the recipient.
  declined,

  /// Invitation has expired (time-based expiration).
  expired,
}

/// Extension methods for [InvitationStatus].
extension InvitationStatusExtension on InvitationStatus {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates an [InvitationStatus] from a stored string value.
  static InvitationStatus fromValue(String value) {
    return InvitationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InvitationStatus.pending,
    );
  }

  /// Returns whether the invitation is still actionable.
  bool get isActionable {
    return this == InvitationStatus.pending;
  }

  /// Returns whether the invitation is final (accepted, declined, or expired).
  bool get isFinal {
    return this == InvitationStatus.accepted ||
        this == InvitationStatus.declined ||
        this == InvitationStatus.expired;
  }

  /// Returns whether the invitation was accepted.
  bool get isAccepted => this == InvitationStatus.accepted;

  /// Returns whether the invitation was declined.
  bool get isDeclined => this == InvitationStatus.declined;

  /// Returns whether the invitation has expired.
  bool get isExpired => this == InvitationStatus.expired;

  /// Returns whether the invitation is pending.
  bool get isPending => this == InvitationStatus.pending;
}
