// lib/domain/value_objects/appearance_settings.dart

import 'package:equatable/equatable.dart';

import '../enums/font_size.dart';

/// Value object representing user appearance preferences.
class AppearanceSettings extends Equatable {
  /// Whether compact mode is enabled (smaller UI elements).
  final bool compactMode;

  /// Whether account balances are shown.
  final bool showBalances;

  /// Whether transaction descriptions are shown.
  final bool showDescriptions;

  /// Font size preference.
  final FontSize fontSize;

  /// Whether animations are enabled.
  final bool animationsEnabled;

  const AppearanceSettings({
    this.compactMode = false,
    this.showBalances = true,
    this.showDescriptions = true,
    this.fontSize = FontSize.medium,
    this.animationsEnabled = true,
  });

  /// Creates a copy of this appearance settings with the given fields replaced.
  AppearanceSettings copyWith({
    bool? compactMode,
    bool? showBalances,
    bool? showDescriptions,
    FontSize? fontSize,
    bool? animationsEnabled,
  }) {
    return AppearanceSettings(
      compactMode: compactMode ?? this.compactMode,
      showBalances: showBalances ?? this.showBalances,
      showDescriptions: showDescriptions ?? this.showDescriptions,
      fontSize: fontSize ?? this.fontSize,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  /// Returns whether compact mode is enabled.
  bool get isCompactMode => compactMode;

  /// Returns whether balances are shown.
  bool get areBalancesShown => showBalances;

  /// Returns whether descriptions are shown.
  bool get areDescriptionsShown => showDescriptions;

  /// Returns whether animations are enabled.
  bool get areAnimationsEnabled => animationsEnabled;

  @override
  List<Object?> get props => [
        compactMode,
        showBalances,
        showDescriptions,
        fontSize,
        animationsEnabled,
      ];
}
