import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Provider for current user state.
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier(ref);
});

/// Notifier for managing current user state.
class CurrentUserNotifier extends StateNotifier<UserModel?> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(null);

  /// Sets the current user.
  void setUser(UserModel user) {
    state = user;
  }

  /// Updates user profile.
  void updateUser(UserModel user) {
    state = user;
  }

  /// Clears the current user (logout).
  void clearUser() {
    state = null;
  }

  /// Fetches user from repository by ID.
  Future<UserModel?> fetchUser(String userId) async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.getUserById(userId);
      state = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// Refreshes current user data.
  Future<UserModel?> refreshUser() async {
    if (state == null) return null;
    return fetchUser(state!.id);
  }

  /// Updates user's email verification status.
  void setEmailVerified(bool verified) {
    if (state != null) {
      state = state!.copyWith(isEmailVerified: verified);
    }
  }

  /// Updates user's profile photo.
  void updatePhotoUrl(String photoUrl) {
    if (state != null) {
      state = state!.copyWith(photoUrl: photoUrl);
    }
  }

  /// Updates user's display name.
  void updateDisplayName(String displayName) {
    if (state != null) {
      state = state!.copyWith(displayName: displayName);
    }
  }

  /// Returns true if user is authenticated.
  bool get isAuthenticated => state != null;

  /// Returns true if user is email verified.
  bool get isEmailVerified => state?.isEmailVerified ?? false;

  /// Returns true if user is active.
  bool get isActive => state?.isActive ?? false;
}
