// lib/presentation/widgets/utility/internal/lifecycle_listener.dart

import 'package:flutter/material.dart';

import '../enums/lifecycle_state.dart';

/// Internal widget for listening to lifecycle changes.
class LifecycleListener extends StatefulWidget {
  final Widget child;
  final void Function(LifecycleState state) onStateChanged;

  const LifecycleListener({
    super.key,
    required this.child,
    required this.onStateChanged,
  });

  @override
  State<LifecycleListener> createState() => _LifecycleListenerState();
}

class _LifecycleListenerState extends State<LifecycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onStateChanged(LifecycleState.resumed);
        break;
      case AppLifecycleState.inactive:
        widget.onStateChanged(LifecycleState.inactive);
        break;
      case AppLifecycleState.paused:
        widget.onStateChanged(LifecycleState.paused);
        break;
      case AppLifecycleState.detached:
        widget.onStateChanged(LifecycleState.detached);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
