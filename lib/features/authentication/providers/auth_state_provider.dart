import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/auth_status.dart';
import '../models/auth_session_model.dart';

/// Auth state class.
class AuthState {
  final AuthStatus status;
  final AuthSessionModel? session;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthSessionModel? session,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, isLoading: $isLoading, error: $error)';
}

/// Provider for auth state.
final authStateProvider = StateProvider<AuthState>((ref) {
  return const AuthState();
});

/// Notifier provider for auth state.
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

/// Auth state notifier.
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setAuthenticated(AuthSessionModel session) {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session,
      error: null,
      isLoading: false,
    );
  }

  void setUnauthenticated() {
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      isLoading: false,
    );
  }

  void setUnverified(AuthSessionModel session) {
    state = state.copyWith(
      status: AuthStatus.unverified,
      session: session,
      error: null,
      isLoading: false,
    );
  }

  void setError(String error) {
    state = state.copyWith(
      status: AuthStatus.failed,
      error: error,
      isLoading: false,
    );
  }

  void setBlocked(String? error) {
    state = state.copyWith(
      status: AuthStatus.blocked,
      error: error,
      isLoading: false,
    );
  }

  void setSessionExpired() {
    state = state.copyWith(
      status: AuthStatus.sessionExpired,
      session: null,
      isLoading: false,
    );
  }

  void reset() {
    state = const AuthState();
  }

  void updateSession(AuthSessionModel session) {
    state = state.copyWith(session: session);
  }
}
