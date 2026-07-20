import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/auth_status.dart';
import '../repositories/auth_repository.dart';
import '../services/session_service.dart';
import '../services/remember_me_service.dart';

/// Splash state class.
class SplashState {
  final bool isLoading;
  final AuthStatus? result;
  final String? error;

  const SplashState({
    this.isLoading = true,
    this.result,
    this.error,
  });

  SplashState copyWith({
    bool? isLoading,
    AuthStatus? result,
    String? error,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'SplashState(isLoading: $isLoading, result: $result, error: $error)';
}

/// Provider for splash state.
final splashStateProvider = StateProvider<SplashState>((ref) {
  return const SplashState();
});

/// Notifier provider for splash logic.
final splashNotifierProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier(ref);
});

/// Splash notifier for handling splash screen logic.
class SplashNotifier extends StateNotifier<SplashState> {
  final Ref ref;

  SplashNotifier(this.ref) : super(const SplashState());

  /// Initializes app and checks auth status.
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      // Check for existing session
      final sessionService = ref.read(sessionServiceProvider);
      final authRepo = ref.read(authRepositoryProvider);
      final rememberMeService = ref.read(rememberMeServiceProvider);

      // Check if remember me is enabled
      final rememberMe = await rememberMeService.getRememberMe();

      if (rememberMe != null && rememberMe.enabled) {
        // Try to restore session
        final session = await sessionService.restoreSession();

        if (session != null) {
          // Validate session
          final isValid = await authRepo.validateSession(session);

          if (isValid) {
            state = state.copyWith(
              isLoading: false,
              result: AuthStatus.authenticated,
            );
            return;
          }
        }

        // Try auto-login with stored credentials
        final autoLoginResult = await authRepo.autoLogin();

        if (autoLoginResult.isSuccess) {
          state = state.copyWith(
            isLoading: false,
            result: AuthStatus.authenticated,
          );
          return;
        }
      }

      // No valid session or remember me
      state = state.copyWith(
        isLoading: false,
        result: AuthStatus.unauthenticated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        result: AuthStatus.failed,
        error: e.toString(),
      );
    }
  }

  /// Resets splash state.
  void reset() {
    state = const SplashState();
  }
}
