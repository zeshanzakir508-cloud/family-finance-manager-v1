import '../models/family_invitation_model.dart';
import '../models/family_activity_model.dart';
import '../models/family_statistics_model.dart';
import '../enums/family_status.dart';
import '../enums/family_role.dart';

/// State class for family management
class FamilyState {
  /// Current family
  final FamilyModel? currentFamily;
  
  /// List of user's families
  final List<FamilyModel> families;
  
  /// Family members
  final List<MemberModel> members;
  
  /// Family invitations
  final List<FamilyInvitationModel> invitations;
  
  /// Family activities
  final List<FamilyActivityModel> activities;
  
  /// Family statistics
  final FamilyStatisticsModel? statistics;
  
  /// Loading state
  final bool isLoading;
  
  /// Error message
  final String? errorMessage;
  
  /// Whether the user is the owner
  final bool isOwner;
  
  /// Whether the user is a moderator
  final bool isModerator;
  
  /// Current user's role
  final FamilyRole? userRole;

  const FamilyState({
    this.currentFamily,
    this.families = const [],
    this.members = const [],
    this.invitations = const [],
    this.activities = const [],
    this.statistics,
    this.isLoading = false,
    this.errorMessage,
    this.isOwner = false,
    this.isModerator = false,
    this.userRole,
  });

  /// Create initial state
  factory FamilyState.initial() {
    return const FamilyState();
  }

  /// Create loading state
  factory FamilyState.loading() {
    return const FamilyState(isLoading: true);
  }

  /// Create error state
  factory FamilyState.error(String message) {
    return FamilyState(
      isLoading: false,
      errorMessage: message,
    );
  }

  /// Copy with updated fields
  FamilyState copyWith({
    FamilyModel? currentFamily,
    List<FamilyModel>? families,
    List<MemberModel>? members,
    List<FamilyInvitationModel>? invitations,
    List<FamilyActivityModel>? activities,
    FamilyStatisticsModel? statistics,
    bool? isLoading,
    String? errorMessage,
    bool? isOwner,
    bool? isModerator,
    FamilyRole? userRole,
  }) {
    return FamilyState(
      currentFamily: currentFamily ?? this.currentFamily,
      families: families ?? this.families,
      members: members ?? this.members,
      invitations: invitations ?? this.invitations,
      activities: activities ?? this.activities,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isOwner: isOwner ?? this.isOwner,
      isModerator: isModerator ?? this.isModerator,
      userRole: userRole ?? this.userRole,
    );
  }

  /// Get active members
  List<MemberModel> get activeMembers =>
      members.where((m) => m.status == MemberStatus.active).toList();

  /// Get pending members
  List<MemberModel> get pendingMembers =>
      members.where((m) => m.status == MemberStatus.pending).toList();

  /// Get suspended members
  List<MemberModel> get suspendedMembers =>
      members.where((m) => m.status == MemberStatus.suspended).toList();

  /// Get pending invitations
  List<FamilyInvitationModel> get pendingInvitations =>
      invitations.where((i) => i.isActive).toList();

  /// Get the owner member
  MemberModel? get owner =>
      members.firstWhereOrNull((m) => m.role == FamilyRole.owner);

  /// Get member count
  int get memberCount => members.length;

  /// Get active member count
  int get activeMemberCount => activeMembers.length;

  /// Get pending invite count
  int get pendingInviteCount => pendingInvitations.length;

  /// Check if user can manage family
  bool get canManageFamily => isOwner || isModerator;

  /// Check if user can invite members
  bool get canInviteMembers => isOwner || isModerator;

  /// Check if user can remove members
  bool get canRemoveMembers => isOwner || isModerator;

  /// Check if user can change roles
  bool get canChangeRoles => isOwner;

  /// Check if user can delete family
  bool get canDeleteFamily => isOwner;

  /// Check if user can transfer ownership
  bool get canTransferOwnership => isOwner;

  /// Check if there are any members
  bool get hasMembers => members.isNotEmpty;

  /// Check if there are any invitations
  bool get hasInvitations => invitations.isNotEmpty;

  /// Check if there are any pending invitations
  bool get hasPendingInvitations => pendingInvitations.isNotEmpty;

  /// Check if the family is full
  bool get isFamilyFull => memberCount >= 50;

  /// Check if the user is the only owner
  bool get isOnlyOwner => isOwner && members.where((m) => m.role == FamilyRole.owner).length == 1;

  /// Check if the family is active
  bool get isFamilyActive => currentFamily?.status == FamilyStatus.active;

  /// Check if the family is archived
  bool get isFamilyArchived => currentFamily?.status == FamilyStatus.archived;

  @override
  String toString() {
    return 'FamilyState(currentFamily: ${currentFamily?.name}, members: $memberCount, isLoading: $isLoading)';
  }
}
