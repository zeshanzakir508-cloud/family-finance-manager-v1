import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

final reportProvider =
    StateNotifierProvider<ReportNotifier, AsyncValue<ReportState>>(
  (ref) => ReportNotifier(),
);

class ReportNotifier extends StateNotifier<AsyncValue<ReportState>> {
  ReportNotifier()
      : super(
          const AsyncValue.data(
            ReportState(),
          ),
        );

  Future<void> generateReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<TransactionModel> transactions,
    required List<AccountModel> accounts,
    required List<CategoryModel> categories,
  }) async {
    state = const AsyncValue.loading();

    // TODO:
    // Generate dashboard statistics.
    // Calculate income, expense, savings,
    // account balances, category summaries,
    // monthly trends and charts.

    state = AsyncValue.data(
      ReportState(
        startDate: startDate,
        endDate: endDate,
        transactions: transactions,
        accounts: accounts,
        categories: categories,
      ),
    );
  }

  Future<void> clear() async {
    state = const AsyncValue.data(
      ReportState(),
    );
  }
}

class ReportState {
  final DateTime? startDate;

  final DateTime? endDate;

  final List<TransactionModel> transactions;

  final List<AccountModel> accounts;

  final List<CategoryModel> categories;

  const ReportState({
    this.startDate,
    this.endDate,
    this.transactions = const [],
    this.accounts = const [],
    this.categories = const [],
  });

  ReportState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<TransactionModel>? transactions,
    List<AccountModel>? accounts,
    List<CategoryModel>? categories,
  }) {
    return ReportState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
    );
  }
}
