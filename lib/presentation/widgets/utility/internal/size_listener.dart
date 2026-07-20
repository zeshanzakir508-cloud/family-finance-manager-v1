// lib/presentation/widgets/utility/internal/size_listener.dart

import 'package:flutter/material.dart';

/// Internal widget for listening to size changes.
class SizeListener extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onSizeChanged;

  const SizeListener({
    super.key,
    required this.child,
    required this.onSizeChanged,
  });

  @override
  State<SizeListener> createState() => _SizeListenerState();
}

class _SizeListenerState extends State<SizeListener> {
  Size? _lastSize;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _notifySize();
        });
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: widget.child,
      ),
    );
  }

  void _notifySize() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      if (_lastSize != size) {
        _lastSize = size;
        widget.onSizeChanged(size);
      }
    }
  }
}
