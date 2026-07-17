import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/family_model.dart';

final familyProvider =
    StateNotifierProvider<FamilyNotifier, AsyncValue<FamilyModel?>>(
  (ref) => FamilyNotifier(),
);

class FamilyNotifier extends StateNotifier<AsyncValue<FamilyModel?>> {
  FamilyNotifier() : super(const AsyncValue.loading());

  StreamSubscription<FamilyModel?>? _subscription;

  Future<void> loadFamily(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to the family document from Firestore repository.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload current family.
  }

  Future<void> clear() async {
    await _subscription?.cancel();
    _subscription = null;
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
