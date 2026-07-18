// lib/domain/value_objects/notification_data.dart

import 'package:equatable/equatable.dart';

import '../enums/notification_entity_type.dart';
import 'notification_extras.dart';

/// Value object representing notification payload data.
///
/// Contains structured data associated with a notification,
/// such as references to related entities and deep link information.
class NotificationData extends Equatable {
  /// ID of the related transaction (if applicable).
  final String? transactionId;

  /// ID of the related account (if applicable).
  final String? accountId;

  /// ID of the related category (if applicable).
  final String? categoryId;

  /// ID of the related family (if applicable).
  final String? familyId;

  /// ID of the related budget (if applicable).
  final String? budgetId;

  /// Deep link URL for navigation.
  final String? deepLink;

  /// Additional custom data.
  final NotificationExtras? extras;

  const NotificationData({
    this.transactionId,
    this.accountId,
    this.categoryId,
    this.familyId,
    this.budgetId,
    this.deepLink,
    this.extras,
  });

  /// Creates a copy of this notification data with the given fields replaced.
  NotificationData copyWith({
    String? transactionId,
    String? accountId,
    String? categoryId,
    String? familyId,
    String? budgetId,
    String? deepLink,
    NotificationExtras? extras,
  }) {
    return NotificationData(
      transactionId: transactionId ?? this.transactionId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      familyId: familyId ?? this.familyId,
      budgetId: budgetId ?? this.budgetId,
      deepLink: deepLink ?? this.deepLink,
      extras: extras ?? this.extras,
    );
  }

  /// Returns true if this notification data has any content.
  bool get hasContent =>
      transactionId != null ||
      accountId != null ||
      categoryId != null ||
      familyId != null ||
      budgetId != null ||
      deepLink != null ||
      (extras != null && extras!.hasContent);

  /// Returns the entity type based on the available data.
  NotificationEntityType? get referencedEntityType {
    if (transactionId != null) return NotificationEntityType.transaction;
    if (accountId != null) return NotificationEntityType.account;
    if (categoryId != null) return NotificationEntityType.category;
    if (familyId != null) return NotificationEntityType.family;
    if (budgetId != null) return NotificationEntityType.budget;
    return null;
  }

  /// Returns the primary entity ID (first non-null ID found).
  String? get primaryEntityId {
    return transactionId ??
        accountId ??
        categoryId ??
        familyId ??
        budgetId;
  }

  @override
  List<Object?> get props => [
        transactionId,
        accountId,
        categoryId,
        familyId,
        budgetId,
        deepLink,
        extras,
      ];
}
