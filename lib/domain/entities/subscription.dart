// lib/domain/entities/subscription.dart

import 'package:equatable/equatable.dart';

import '../enums/subscription_status.dart';
import '../enums/payment_provider.dart';
import '../enums/payment_method.dart';
import '../enums/subscription_feature.dart';
import '../value_objects/subscription_metadata.dart';

/// Subscription entity representing a user's subscription.
///
/// This entity tracks a user's subscription to a plan, including
/// status, payment details, and renewal information.
class Subscription extends Equatable {
  /// Unique identifier for the subscription.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the user who owns this subscription.
  final String userId;

  /// ID of the subscription plan.
  final String planId;

  /// Status of the subscription.
  final SubscriptionStatus status;

  /// Date when the subscription started.
  final DateTime startDate;

  /// Date when the subscription ends (if active).
  final DateTime? endDate;

  /// Whether auto-renewal is enabled.
  final bool autoRenew;

  /// Payment method.
  final PaymentMethod? paymentMethod;

  /// Payment provider.
  final PaymentProvider? paymentProvider;

  /// Provider's subscription ID (e.g., Stripe subscription ID).
  final String? providerSubscriptionId;

  /// Date when the trial period ends (if applicable).
  final DateTime? trialEndDate;

  /// Date when the subscription was cancelled.
  final DateTime? cancelledAt;

  /// Reason for cancellation (if applicable).
  final String? cancelledReason;

  /// Date of the last payment.
  final DateTime? lastPaymentDate;

  /// Date of the next payment (if applicable).
  final DateTime? nextPaymentDate;

  /// Features included in this subscription.
  final List<SubscriptionFeature> features;

  /// Additional metadata.
  final SubscriptionMetadata metadata;

  const Subscription({
    this.id,
    required this.userId,
    required this.planId,
    this.status = SubscriptionStatus.inactive,
    required this.startDate,
    this.endDate,
    this.autoRenew = false,
    this.paymentMethod,
    this.paymentProvider,
    this.providerSubscriptionId,
    this.trialEndDate,
    this.cancelledAt,
    this.cancelledReason,
    this.lastPaymentDate,
    this.nextPaymentDate,
    this.features = const [],
    this.metadata = const SubscriptionMetadata(),
  });

  /// Creates a copy of this subscription with the given fields replaced.
  Subscription copyWith({
    String? id,
    String? userId,
    String? planId,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    PaymentMethod? paymentMethod,
    PaymentProvider? paymentProvider,
    String? providerSubscriptionId,
    DateTime? trialEndDate,
    DateTime? cancelledAt,
    String? cancelledReason,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    List<SubscriptionFeature>? features,
    SubscriptionMetadata? metadata,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoRenew: autoRenew ?? this.autoRenew,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      providerSubscriptionId: providerSubscriptionId ?? this.providerSubscriptionId,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelledReason: cancelledReason ?? this.cancelledReason,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      features: features ?? this.features,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns whether the subscription is active.
  bool get isActive => status == SubscriptionStatus.active;

  /// Returns whether the subscription is cancelled.
  bool get isCancelled => status == SubscriptionStatus.cancelled;

  /// Returns whether the subscription is expired.
  bool get isExpired => status == SubscriptionStatus.expired;

  /// Checks if the subscription is in trial period at the given time.
  bool isInTrialAt(DateTime currentTime) {
    if (trialEndDate == null) return false;
    return currentTime.isBefore(trialEndDate!);
  }

  /// Checks if the subscription has ended at the given time.
  bool hasEndedAt(DateTime currentTime) {
    if (endDate == null) return false;
    return currentTime.isAfter(endDate!);
  }

  /// Returns the number of days remaining at the given time.
  int daysRemainingAt(DateTime currentTime) {
    if (endDate == null) return 0;
    final difference = endDate!.difference(currentTime);
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  /// Checks if the subscription is valid at the given time.
  bool isValidAt(DateTime currentTime) {
    return isActive && !hasEndedAt(currentTime);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        status,
        startDate,
        endDate,
        autoRenew,
        paymentMethod,
        paymentProvider,
        providerSubscriptionId,
        trialEndDate,
        cancelledAt,
        cancelledReason,
        lastPaymentDate,
        nextPaymentDate,
        features,
        metadata,
      ];
}
