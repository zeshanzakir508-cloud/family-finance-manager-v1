import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/account_model.dart';

final accountProvider =
    StateNotifierProvider<AccountNotifier, AsyncValue<List<AccountModel>>>(
  (ref) => AccountNotifier(),
);

class AccountNotifier
    extends StateNotifier<AsyncValue<List<AccountModel>>> {
  AccountNotifier() : super(const AsyncValue.loading());

  StreamSubscription<List<AccountModel>>? _subscription;

  Future<void> loadAccounts(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to all accounts belonging to the family.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload account list.
  }

  Future<void> clear() async {
    await _subscription?.cancel();
    _subscription = null;
    state = const AsyncValue.data([]);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
