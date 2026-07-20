// lib/presentation/widgets/domain/accounts/account_selector.dart

import 'package:flutter/material.dart';

import '../../buttons/app_button.dart';
import '../../buttons/enums/app_button_variant.dart';
import '../../buttons/enums/app_button_size.dart';
import '../../overlays/app_bottom_sheet.dart';
import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';

/// A widget for selecting an account from a list.
///
/// This widget provides a standardized account selector for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// AccountSelector(
///   accounts: accounts,
///   selectedAccount: selectedAccount,
///   onAccountSelected: (account) => setState(() => selectedAccount = account),
/// )
/// ```
class AccountSelector extends StatelessWidget {
  /// The list of accounts.
  final List<AccountOption> accounts;

  /// The currently selected account.
  final AccountOption? selectedAccount;

  /// Callback when an account is selected.
  final ValueChanged<AccountOption>? onAccountSelected;

  /// The label text.
  final String label;

  /// Whether the selector is disabled.
  final bool isDisabled;

  /// Creates a new [AccountSelector].
  const AccountSelector({
    super.key,
    required this.accounts,
    this.selectedAccount,
    this.onAccountSelected,
    this.label = 'Select Account',
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: selectedAccount?.label ?? label,
      onPressed: isDisabled ? null : () => _showAccountPicker(context),
      variant: AppButtonVariant.outlined,
      size: AppButtonSize.medium,
      isDisabled: isDisabled || accounts.isEmpty,
      leadingIcon: selectedAccount?.icon != null
          ? Icon(selectedAccount!.icon, size: 20)
          : null,
    );
  }

  void _showAccountPicker(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: accounts.map((account) {
          final isSelected = selectedAccount?.id == account.id;
          return AppTile(
            title: account.label,
            subtitle: account.subtitle,
            leading: account.icon != null
                ? Icon(account.icon)
                : null,
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              onAccountSelected?.call(account);
              Navigator.of(context).pop();
            },
            selected: isSelected,
            variant: TileVariant.filled,
          );
        }).toList(),
      ),
    );
  }
}

/// An account option for the selector.
class AccountOption {
  /// The unique ID of the account.
  final String id;

  /// The display label.
  final String label;

  /// The optional subtitle.
  final String? subtitle;

  /// The optional icon.
  final IconData? icon;

  /// Creates a new [AccountOption].
  const AccountOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.icon,
  });
}
