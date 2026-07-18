// lib/domain/entities/family_invitation.dart

import 'package:equatable/equatable.dart';

import '../enums/invitation_status.dart';

/// Family invitation entity representing an invitation to join a family.
///
/// This entity tracks invitations sent to users to join a family,
/// including the invitation status, expiration, and related metadata.
class FamilyInvitation extends Equatable {
  /// Unique identifier for the invitation.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the family the user is invited to join.
  final String familyId;

  /// Email of the invited user.
  final String email;

  /// ID of the user who sent the invitation (if registered).
  final String? invitedBy;

  /// ID of the user who accepted the invitation (if registered).
  final String? invitedUserId;

  /// Status of the invitation.
  final InvitationStatus status;

  /// Date when the invitation was sent.
  final DateTime sentAt;

  /// Date when the invitation expires.
  final DateTime expiresAt;

  /// Date when the invitation was responded to (accepted/declined).
  final DateTime? respondedAt;

  /// Optional message from the inviter.
  final String? message;

  const FamilyInvitation({
    this.id,
    required this.familyId,
    required this.email,
    this.invitedBy,
    this.invitedUserId,
    this.status = InvitationStatus.pending,
    required this.sentAt,
    required this.expiresAt,
    this.respondedAt,
    this.message,
  });

  /// Creates a copy of this invitation with the given fields replaced.
  FamilyInvitation copyWith({
    String? id,
    String? familyId,
    String? email,
    String? invitedBy,
    String? invitedUserId,
    InvitationStatus? status,
    DateTime? sentAt,
    DateTime? expiresAt,
    DateTime? respondedAt,
    String? message,
  }) {
    return FamilyInvitation(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      email: email ?? this.email,
      invitedBy: invitedBy ?? this.invitedBy,
      invitedUserId: invitedUserId ?? this.invitedUserId,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }

  /// Checks if the invitation is valid at the given time.
  bool isValidAt(DateTime currentTime) =>
      status == InvitationStatus.pending && !isExpiredAt(currentTime);

  /// Checks if the invitation has expired at the given time.
  bool isExpiredAt(DateTime currentTime) =>
      currentTime.isAfter(expiresAt);

  /// Checks if the invitation was accepted.
  bool get isAccepted => status == InvitationStatus.accepted;

  /// Checks if the invitation was declined.
  bool get isDeclined => status == InvitationStatus.declined;

  /// Accepts the invitation at the given time.
  ///
  /// Throws [StateError] if the invitation is not in a valid state to accept.
  FamilyInvitation accept(String userId, DateTime acceptedAt) {
    if (status != InvitationStatus.pending) {
      throw StateError('Cannot accept an invitation that is already $status.');
    }
    if (isExpiredAt(acceptedAt)) {
      throw StateError('Cannot accept an expired invitation.');
    }

    return copyWith(
      status: InvitationStatus.accepted,
      invitedUserId: userId,
      respondedAt: acceptedAt,
    );
  }

  /// Declines the invitation at the given time.
  ///
  /// Throws [StateError] if the invitation is not in a valid state to decline.
  FamilyInvitation decline(DateTime declinedAt) {
    if (status != InvitationStatus.pending) {
      throw StateError('Cannot decline an invitation that is already $status.');
    }
    if (isExpiredAt(declinedAt)) {
      throw StateError('Cannot decline an expired invitation.');
    }

    return copyWith(
      status: InvitationStatus.declined,
      respondedAt: declinedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        familyId,
        email,
        invitedBy,
        invitedUserId,
        status,
        sentAt,
        expiresAt,
        respondedAt,
        message,
      ];
}
