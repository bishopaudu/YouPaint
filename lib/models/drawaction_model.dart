import 'dart:ui';

class DrawAction {
  final Offset position;
  final DateTime timestamp;
  final Color color;
  final Size size;

  DrawAction({
    required this.position,
    required this.timestamp,
    required this.color,
    required  this.size
  });
}
