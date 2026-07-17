import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'firebase_provider.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentFirebaseUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentFirebaseUserProvider)?.uid;
});

final userModelProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  (ref) => UserNotifier(ref),
);

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _listenToAuthState();
  }

  final Ref ref;

  StreamSubscription<User?>? _subscription;

  void _listenToAuthState() {
    _subscription = ref
        .read(firebaseAuthProvider)
        .authStateChanges()
        .listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      state = const AsyncValue.data(null);
      return;
    }

    // TODO:
    // Load UserModel from Firestore repository.
    state = const AsyncValue.loading();
  }

  Future<void> refresh() async {
    final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
    await _onAuthStateChanged(firebaseUser);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
