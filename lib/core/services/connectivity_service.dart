import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// ============================================================================
/// Family Finance Manager
/// Connectivity Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Connectivity Plus.
///
/// Responsibilities:
/// • Check current connectivity
/// • Listen for connectivity changes
/// • Determine online/offline state
///
/// NOTE:
/// This service reports network connectivity only.
/// It does NOT guarantee actual internet access.
/// ============================================================================
class ConnectivityService {
  ConnectivityService({
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Returns the current connectivity status.
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Returns true if at least one active network exists.
  Future<bool> isConnected() async {
    final results = await checkConnectivity();

    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }

  /// Returns true if there is no active network.
  Future<bool> isDisconnected() async {
    return !(await isConnected());
  }

  /// Listens for connectivity changes.
  void listen(
    FutureOr<void> Function(List<ConnectivityResult> results) onChanged,
  ) {
    _subscription?.cancel();

    _subscription = onConnectivityChanged.listen(onChanged);
  }

  /// Stops listening for connectivity changes.
  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  /// Releases resources.
  Future<void> dispose() async {
    await cancel();
  }
}
