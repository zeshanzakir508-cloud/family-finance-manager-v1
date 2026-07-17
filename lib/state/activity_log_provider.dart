import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity_log_model.dart';

final activityLogProvider = StateNotifierProvider<ActivityLogNotifier,
    AsyncValue<List<ActivityLogModel>>>(
  (ref) => ActivityLogNotifier(),
);

class ActivityLogNotifier
    extends StateNotifier<AsyncValue<List<ActivityLogModel>>> {
  ActivityLogNotifier() : super(const AsyncValue.loading());

  StreamSubscription<List<ActivityLogModel>>? _subscription;

  Future<void> loadActivityLogs(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to activity logs for the family.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload activity logs.
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
