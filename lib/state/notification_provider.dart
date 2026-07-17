import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';

final notificationProvider = StateNotifierProvider<
    NotificationNotifier, AsyncValue<List<NotificationModel>>>(
  (ref) => NotificationNotifier(),
);

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  NotificationNotifier() : super(const AsyncValue.loading());

  StreamSubscription<List<NotificationModel>>? _subscription;

  Future<void> loadNotifications(String userId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Listen to all notifications belonging to the user.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload notification list.
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
