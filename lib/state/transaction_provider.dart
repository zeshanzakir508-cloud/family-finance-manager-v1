import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_model.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier,
    AsyncValue<List<TransactionModel>>>(
  (ref) => TransactionNotifier(),
);

class TransactionNotifier
    extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  TransactionNotifier() : super(const AsyncValue.loading());

  StreamSubscription<List<TransactionModel>>? _subscription;

  Future<void> loadTransactions(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to all transactions belonging to the family.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload transaction list.
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
