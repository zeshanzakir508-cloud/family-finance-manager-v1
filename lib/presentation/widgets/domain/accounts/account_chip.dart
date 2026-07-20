// lib/presentation/widgets/domain/accounts/account_chip.dart

import 'package:flutter/material.dart';

import '../../chips/app_chip.dart';
import '../../chips/enums/chip_variant.dart';
import '../../chips/enums/chip_size.dart';

/// A chip representing an account.
///
/// This widget provides a standardized account chip for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// AccountChip(
///   label: 'Cash',
///   icon: Icons.money,
///   isSelected: isSelected,
/// )
/// ```
class AccountChip extends StatelessWidget {
  /// The account label.
  final String label;

  /// The account icon.
  final IconData? icon;

  /// Whether the chip is selected.
  final bool isSelected;

  /// Callback when the chip is pressed.
  final VoidCallback? onPressed;

  /// Whether the chip is disabled.
  final bool isDisabled;

  /// Creates a new [AccountChip].
  const AccountChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      avatar: icon != null ? Icon(icon, size: 16) : null,
      selected: isSelected,
      onPressed: onPressed,
      isDisabled: isDisabled,
      variant: isSelected ? ChipVariant.filled : ChipVariant.outlined,
      size: ChipSize.medium,
    );
  }
}
