// lib/presentation/widgets/overlays/internal/overlay_arrow.dart

import 'package:flutter/material.dart';

import '../enums/overlay_position.dart';

/// Internal widget for rendering overlay arrow.
class OverlayArrow extends StatelessWidget {
  final OverlayPosition position;
  final Color color;
  final double size;

  const OverlayArrow({
    super.key,
    required this.position,
    required this.color,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 2, size * 2),
      painter: _ArrowPainter(
        position: position,
        color: color,
        size: size,
      ),
    );
  }
}

/// Internal painter for overlay arrow.
class _ArrowPainter extends CustomPainter {
  final OverlayPosition position;
  final Color color;
  final double size;

  const _ArrowPainter({
    required this.position,
    required this.color,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (position) {
      case OverlayPosition.top:
        path.moveTo(this.size, 0);
        path.lineTo(0, this.size);
        path.lineTo(this.size * 2, this.size);
        path.close();
        break;

      case OverlayPosition.bottom:
        path.moveTo(0, 0);
        path.lineTo(this.size * 2, 0);
        path.lineTo(this.size, this.size);
        path.close();
        break;

      case OverlayPosition.left:
        path.moveTo(0, this.size);
        path.lineTo(this.size, 0);
        path.lineTo(this.size, this.size * 2);
        path.close();
        break;

      case OverlayPosition.right:
        path.moveTo(this.size, 0);
        path.lineTo(0, this.size);
        path.lineTo(this.size, this.size * 2);
        path.close();
        break;

      default:
        path.moveTo(this.size, 0);
        path.lineTo(0, this.size);
        path.lineTo(this.size * 2, this.size);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
