// lib/presentation/widgets/utility/internal/keyboard_listener.dart

import 'package:flutter/material.dart';

/// Internal widget for listening to keyboard changes.
class KeyboardListener extends StatefulWidget {
  final Widget child;
  final void Function(bool isVisible, double height) onChanged;

  const KeyboardListener({
    super.key,
    required this.child,
    required this.onChanged,
  });

  @override
  State<KeyboardListener> createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<KeyboardListener> {
  bool _lastVisible = false;
  double _lastHeight = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkKeyboard();
        return false;
      },
      child: widget.child,
    );
  }

  void _checkKeyboard() {
    final isVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final height = MediaQuery.of(context).viewInsets.bottom;

    if (_lastVisible != isVisible || _lastHeight != height) {
      _lastVisible = isVisible;
      _lastHeight = height;
      widget.onChanged(isVisible, height);
    }
  }
}
