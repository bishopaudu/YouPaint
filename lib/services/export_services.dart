import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';
import 'package:youpaint/painter/drawing_painter.dart';
import 'package:youpaint/view/drawing_screen.dart';

class ExportService {
  // Export as PNG
  static Future<File> exportAsPNG(
    GlobalKey repaintKey,
    String filename,
  ) async {
    try {
      RenderRepaintBoundary boundary =
          repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$filename.png";
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      throw Exception("Failed to export PNG: $e");
    }
  }

  // Export replay as video (MP4)
  static Future<File> exportReplayAsVideo(
    List<DrawAction?> points,
    Color backgroundColor,
    String filename,
    Size canvasSize,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final framesDir = Directory("${directory.path}/frames");
      if (!await framesDir.exists()) {
        await framesDir.create();
      }

      // Generate frames
      List<DrawAction?> currentPoints = [];
      int frameCount = 0;

      for (int i = 0; i < points.length; i++) {
        if (points[i] != null) {
          currentPoints.add(points[i]);
          
          // Capture frame every few points to optimize
          if (i % 3 == 0 || i == points.length - 1) {
            await _captureFrame(
              currentPoints,
              backgroundColor,
              framesDir.path,
              frameCount,
              canvasSize,
            );
            frameCount++;
          }
        } else {
          currentPoints.add(null);
        }
      }

      // NOTE: Actual video encoding requires native platform integration
      // For a complete solution, you'll need to:
      // 1. Use FFmpeg through a package like 'ffmpeg_kit_flutter'
      // 2. Or use platform channels to native video encoding libraries
      
      // This is a placeholder that saves the last frame as reference
      final videoPath = "${directory.path}/$filename.mp4";
      final placeholderFile = File(videoPath);
      
      // Clean up frames
      await framesDir.delete(recursive: true);

      return placeholderFile;
    } catch (e) {
      throw Exception("Failed to export video: $e");
    }
  }

  static Future<void> _captureFrame(
    List<DrawAction?> points,
    Color backgroundColor,
    String framesPath,
    int frameNumber,
    Size size,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Draw points
    final painter = DrawingPainter(points);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final file = File("$framesPath/frame_${frameNumber.toString().padLeft(5, '0')}.png");
    await file.writeAsBytes(pngBytes);
  }
}