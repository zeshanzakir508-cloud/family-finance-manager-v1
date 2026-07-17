import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>(
  (ref) => CategoryNotifier(),
);

class CategoryNotifier
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoryNotifier() : super(const AsyncValue.loading());

  StreamSubscription<List<CategoryModel>>? _subscription;

  Future<void> loadCategories(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to all categories belonging to the family.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload category list.
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
