import 'package:flutter/material.dart';
import '../models/drawaction_model.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawAction?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        final paint = Paint()
          ..color = current.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = current.size.width;

        canvas.drawLine(current.position, next.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}