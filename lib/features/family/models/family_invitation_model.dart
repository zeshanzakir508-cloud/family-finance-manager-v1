import 'package:flutter/foundation.dart';
import '../enums/invite_status.dart';

/// Model representing a family invitation
class FamilyInvitationModel {
  /// Unique identifier for the invitation
  final String id;
  
  /// Family ID this invitation belongs to
  final String familyId;
  
  /// Invitation code (6 characters)
  final String code;
  
  /// Email of the invited person
  final String? email;
  
  /// Phone number of the invited person
  final String? phone;
  
  /// Name of the invited person
  final String? name;
  
  /// ID of the member who sent the invitation
  final String invitedBy;
  
  /// Role to assign when the invitation is accepted
  final String role;
  
  /// Status of the invitation
  final InviteStatus status;
  
  /// Timestamp when the invitation was created
  final DateTime createdAt;
  
  /// Timestamp when the invitation expires
  final DateTime expiresAt;
  
  /// Timestamp when the invitation was responded to
  final DateTime? respondedAt;
  
  /// Number of times the invitation was resent
  final int resendCount;
  
  /// Any additional metadata
  final Map<String, dynamic>? metadata;

  /// Constructor
  const FamilyInvitationModel({
    required this.id,
    required this.familyId,
    required this.code,
    this.email,
    this.phone,
    this.name,
    required this.invitedBy,
    required this.role,
    this.status = InviteStatus.pending,
    required this.createdAt,
    required this.expiresAt,
    this.respondedAt,
    this.resendCount = 0,
    this.metadata,
  });

  /// Create from JSON
  factory FamilyInvitationModel.fromJson(Map<String, dynamic> json) {
    return FamilyInvitationModel(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      code: json['code'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      invitedBy: json['invitedBy'] as String,
      role: json['role'] as String,
      status: InviteStatusExtension.fromString(
        json['status'] as String? ?? 'pending',
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      resendCount: json['resendCount'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'familyId': familyId,
      'code': code,
      'email': email,
      'phone': phone,
      'name': name,
      'invitedBy': invitedBy,
      'role': role,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'resendCount': resendCount,
      'metadata': metadata,
    };
  }

  /// Check if the invitation is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if the invitation is active (pending and not expired)
  bool get isActive {
    return status == InviteStatus.pending && !isExpired;
  }

  /// Check if the invitation has a contact method
  bool get hasContact {
    return email != null || phone != null;
  }

  /// Get the contact method display string
  String get contactDisplay {
    if (email != null) return email!;
    if (phone != null) return phone!;
    return 'No contact';
  }

  /// Get the display name for the invite
  String get displayName {
    return name ?? contactDisplay;
  }

  /// Create a copy with updated fields
  FamilyInvitationModel copyWith({
    String? id,
    String? familyId,
    String? code,
    String? email,
    String? phone,
    String? name,
    String? invitedBy,
    String? role,
    InviteStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? respondedAt,
    int? resendCount,
    Map<String, dynamic>? metadata,
  }) {
    return FamilyInvitationModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      code: code ?? this.code,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      invitedBy: invitedBy ?? this.invitedBy,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
      resendCount: resendCount ?? this.resendCount,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Accept the invitation
  FamilyInvitationModel accept() {
    return copyWith(
      status: InviteStatus.accepted,
      respondedAt: DateTime.now(),
    );
  }

  /// Reject the invitation
  FamilyInvitationModel reject() {
    return copyWith(
      status: InviteStatus.rejected,
      respondedAt: DateTime.now(),
    );
  }

  /// Cancel the invitation
  FamilyInvitationModel cancel() {
    return copyWith(
      status: InviteStatus.cancelled,
      respondedAt: DateTime.now(),
    );
  }

  /// Expire the invitation
  FamilyInvitationModel expire() {
    return copyWith(
      status: InviteStatus.expired,
    );
  }

  /// Resend the invitation
  FamilyInvitationModel resend() {
    return copyWith(
      resendCount: resendCount + 1,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      status: InviteStatus.pending,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyInvitationModel &&
        other.id == id &&
        other.familyId == familyId &&
        other.code == code &&
        other.email == email &&
        other.phone == phone &&
        other.name == name &&
        other.invitedBy == invitedBy &&
        other.role == role &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.respondedAt == respondedAt &&
        other.resendCount == resendCount &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyId,
      code,
      email,
      phone,
      name,
      invitedBy,
      role,
      status,
      createdAt,
      expiresAt,
      respondedAt,
      resendCount,
      metadata,
    );
  }

  @override
  String toString() {
    return 'FamilyInvitationModel(id: $id, familyId: $familyId, code: $code, status: ${status.displayName})';
  }
}
