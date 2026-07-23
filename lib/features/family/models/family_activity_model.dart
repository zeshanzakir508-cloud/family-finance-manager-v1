import 'package:flutter/foundation.dart';

/// Model representing a family activity log entry
class FamilyActivityModel {
  /// Unique identifier
  final String id;
  
  /// Family ID this activity belongs to
  final String familyId;
  
  /// ID of the member who performed the action
  final String memberId;
  
  /// Name of the member (for display purposes)
  final String? memberName;
  
  /// Type of activity
  final String type;
  
  /// Description of the activity
  final String description;
  
  /// Additional data about the activity
  final Map<String, dynamic>? data;
  
  /// Timestamp when the activity occurred
  final DateTime timestamp;
  
  /// Severity level (info, warning, error, etc.)
  final String severity;

  /// Constructor
  const FamilyActivityModel({
    required this.id,
    required this.familyId,
    required this.memberId,
    this.memberName,
    required this.type,
    required this.description,
    this.data,
    required this.timestamp,
    this.severity = 'info',
  });

  /// Create from JSON
  factory FamilyActivityModel.fromJson(Map<String, dynamic> json) {
    return FamilyActivityModel(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String?,
      type: json['type'] as String,
      description: json['description'] as String,
      data: json['data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: json['severity'] as String? ?? 'info',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'familyId': familyId,
      'memberId': memberId,
      'memberName': memberName,
      'type': type,
      'description': description,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
    };
  }

  /// Get the time since the activity occurred
  Duration get timeSince {
    return DateTime.now().difference(timestamp);
  }

  /// Get a formatted time string
  String get formattedTime {
    final diff = timeSince;
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    return 'Just now';
  }

  /// Check if the activity is recent (within 24 hours)
  bool get isRecent {
    return timeSince.inHours < 24;
  }

  /// Check if the activity is a member-related event
  bool get isMemberEvent {
    return type.startsWith('member_');
  }

  /// Check if the activity is a family-related event
  bool get isFamilyEvent {
    return type.startsWith('family_');
  }

  /// Check if the activity is a system event
  bool get isSystemEvent {
    return type == 'system' || type.startsWith('system_');
  }

  /// Create a copy with updated fields
  FamilyActivityModel copyWith({
    String? id,
    String? familyId,
    String? memberId,
    String? memberName,
    String? type,
    String? description,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    String? severity,
  }) {
    return FamilyActivityModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      type: type ?? this.type,
      description: description ?? this.description,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyActivityModel &&
        other.id == id &&
        other.familyId == familyId &&
        other.memberId == memberId &&
        other.memberName == memberName &&
        other.type == type &&
        other.description == description &&
        mapEquals(other.data, data) &&
        other.timestamp == timestamp &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyId,
      memberId,
      memberName,
      type,
      description,
      data,
      timestamp,
      severity,
    );
  }

  @override
  String toString() {
    return 'FamilyActivityModel(type: $type, timestamp: $timestamp, description: $description)';
  }
}

/// Activity type constants
class ActivityTypes {
  // Member events
  static const String memberJoined = 'member_joined';
  static const String memberLeft = 'member_left';
  static const String memberRemoved = 'member_removed';
  static const String memberInvited = 'member_invited';
  static const String memberRoleChanged = 'member_role_changed';
  static const String memberSuspended = 'member_suspended';
  static const String memberRestored = 'member_restored';
  
  // Family events
  static const String familyCreated = 'family_created';
  static const String familyUpdated = 'family_updated';
  static const String familyDeleted = 'family_deleted';
  static const String familyArchived = 'family_archived';
  static const String ownershipTransferred = 'ownership_transferred';
  
  // Invitation events
  static const String inviteSent = 'invite_sent';
  static const String inviteAccepted = 'invite_accepted';
  static const String inviteRejected = 'invite_rejected';
  static const String inviteCancelled = 'invite_cancelled';
  static const String inviteExpired = 'invite_expired';
  
  // System events
  static const String system = 'system';
}
