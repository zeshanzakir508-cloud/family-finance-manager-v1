// lib/domain/entities/family.dart

import 'package:equatable/equatable.dart';

import '../value_objects/family_settings.dart';

/// Family entity representing a family group.
///
/// Families allow users to share accounts, categories, and transactions
/// with other members. Each family has a unique join code for invitations.
class Family extends Equatable {
  /// Unique identifier for the family.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// Name of the family.
  final String name;

  /// Optional description of the family.
  final String? description;

  /// Icon name or emoji for the family.
  final String? icon;

  /// Color hex code for the family.
  final String? color;

  /// ID of the user who created the family.
  final String createdBy;

  /// Whether the family is active.
  final bool isActive;

  /// Join code for inviting new members.
  final String? joinCode;

  /// Maximum number of members allowed in the family.
  final int maxMembers;

  /// Family settings.
  final FamilySettings settings;

  const Family({
    this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.createdBy,
    this.isActive = true,
    this.joinCode,
    this.maxMembers = 10,
    this.settings = const FamilySettings(),
  });

  /// Creates a copy of this family with the given fields replaced.
  Family copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? createdBy,
    bool? isActive,
    String? joinCode,
    int? maxMembers,
    FamilySettings? settings,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      joinCode: joinCode ?? this.joinCode,
      maxMembers: maxMembers ?? this.maxMembers,
      settings: settings ?? this.settings,
    );
  }

  /// Returns whether the family is full.
  bool isFull(int currentMemberCount) => currentMemberCount >= maxMembers;

  /// Returns whether the family has a join code.
  bool get hasJoinCode => joinCode != null && joinCode!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        color,
        createdBy,
        isActive,
        joinCode,
        maxMembers,
        settings,
      ];
}
