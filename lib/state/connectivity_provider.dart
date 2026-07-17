import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();

  final controller = StreamController<ConnectivityResult>();

  Future<void> emitCurrentStatus() async {
    final result = await connectivity.checkConnectivity();

    if (result is List<ConnectivityResult>) {
      controller.add(
        result.isEmpty ? ConnectivityResult.none : result.first,
      );
    } else {
      controller.add(result as ConnectivityResult);
    }
  }

  emitCurrentStatus();

  final subscription = connectivity.onConnectivityChanged.listen((result) {
    if (result is List<ConnectivityResult>) {
      controller.add(
        result.isEmpty ? ConnectivityResult.none : result.first,
      );
    } else {
      controller.add(result as ConnectivityResult);
    }
  });

  ref.onDispose(() async {
    await subscription.cancel();
    await controller.close();
  });

  return controller.stream;
});
