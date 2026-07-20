import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/session_status.dart';
import '../models/auth_session_model.dart';
import '../services/session_service.dart';

/// Session state class.
class SessionState {
  final SessionStatus status;
  final AuthSessionModel? session;
  final DateTime? lastActivity;
  final String? error;

  const SessionState({
    this.status = SessionStatus.active,
    this.session,
    this.lastActivity,
    this.error,
  });

  SessionState copyWith({
    SessionStatus? status,
    AuthSessionModel? session,
    DateTime? lastActivity,
    String? error,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      lastActivity: lastActivity ?? this.lastActivity,
      error: error ?? this.error,
    );
  }

  bool get isValid => status == SessionStatus.active || status == SessionStatus.refreshed;
  bool get isExpired => status == SessionStatus.expired;
  bool get isExpiring => status == SessionStatus.expiring;
}

/// Provider for session state.
final sessionStateProvider = StateProvider<SessionState>((ref) {
  return const SessionState();
});

/// Provider for session service.
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService();
});

/// Notifier provider for session management.
final sessionNotifierProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref);
});

/// Session notifier for managing session state.
class SessionNotifier extends StateNotifier<SessionState> {
  final Ref ref;

  SessionNotifier(this.ref) : super(const SessionState());

  /// Sets the session.
  void setSession(AuthSessionModel session) {
    state = state.copyWith(
      session: session,
      status: SessionStatus.active,
      lastActivity: DateTime.now(),
      error: null,
    );
  }

  /// Updates last activity time.
  void updateActivity() {
    state = state.copyWith(lastActivity: DateTime.now());
  }

  /// Marks session as expired.
  void setExpired() {
    state = state.copyWith(
      status: SessionStatus.expired,
      session: null,
    );
  }

  /// Marks session as expiring soon.
  void setExpiring() {
    state = state.copyWith(status: SessionStatus.expiring);
  }

  /// Refreshes the session with new tokens.
  void refreshSession(AuthSessionModel newSession) {
    state = state.copyWith(
      session: newSession,
      status: SessionStatus.refreshed,
      lastActivity: DateTime.now(),
    );
  }

  /// Sets session renewing state.
  void setRenewing() {
    state = state.copyWith(status: SessionStatus.renewing);
  }

  /// Invalidates the session.
  void invalidate() {
    state = const SessionState(status: SessionStatus.invalidated);
  }

  /// Clears session state.
  void clear() {
    state = const SessionState();
  }

  /// Sets error.
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  /// Checks if session needs refresh.
  bool get needsRefresh {
    final session = state.session;
    if (session == null) return false;
    return session.isExpiringSoon || session.isExpired;
  }

  /// Returns remaining time for session.
  Duration get remainingTime {
    final session = state.session;
    if (session == null) return Duration.zero;
    return session.timeRemaining;
  }
}
