import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/models/drawaction_model.dart';
import 'package:youpaint/painter/drawing_painter.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';


class DrawingCanvas extends StatelessWidget {
  final GlobalKey repaintKey;
  final double height;

  const DrawingCanvas({
    Key? key,
    required this.repaintKey,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, service, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RepaintBoundary(
              key: repaintKey,
              child: Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: service.backgroundColor,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onPanStart: (details) => service.saveToHistory(),
                  onPanUpdate: (details) {
                    service.addPoint(DrawAction(
                      position: details.localPosition,
                      timestamp: DateTime.now(),
                      color: service.isEraser
                          ? service.backgroundColor
                          : service.selectedColor.withOpacity(service.opacity),
                      size: Size(service.brushSize, service.brushSize),
                    ));
                  },
                  onPanEnd: (details) => service.addPoint(null),
                  child: CustomPaint(
                    painter: DrawingPainter(
                      service.isReplaying ? service.replayedPoints : service.points,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
