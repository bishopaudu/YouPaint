import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';
import 'package:youpaint/painter/drawing_painter.dart';

class ExportService {
  static const MethodChannel _channel = MethodChannel('com.example.youpaint/video_export');

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
      
      // Save to Gallery
      await Gal.putImage(filePath);

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
    Size canvasSize, {
    Function(double progress)? onProgress,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final framesDir = Directory("${directory.path}/frames");
      
      // Robust initial cleanup
      await _robustDirectoryCleanup(framesDir);
      
      if (!await framesDir.exists()) {
        await framesDir.create();
      }

      // Generate frames
      List<DrawAction?> currentPoints = [];
      List<String> framePaths = [];
      int frameCount = 0;

      // Calculate capturing interval based on points length
      int step = 1;
      if (points.length > 300) {
        step = (points.length / 300).ceil();
      }

      int totalPoints = points.length;

      for (int i = 0; i < totalPoints; i++) {
        // Update progress (0.0 to 0.8 during frame generation)
        if (onProgress != null && i % 10 == 0) {
          onProgress(0.8 * (i / totalPoints));
        }

        if (points[i] != null) {
          currentPoints.add(points[i]);
          
          // Capture frame
          if (i % step == 0 || i == points.length - 1) {
             await _captureFrame(
              currentPoints,
              backgroundColor,
              framesDir.path,
              frameCount,
              canvasSize,
            );
            framePaths.add("${framesDir.path}/frame_${frameCount.toString().padLeft(5, '0')}.png");
            frameCount++;
          }
        } else {
          currentPoints.add(null);
        }
      }
      
      // Progress: Encoding started (0.8)
      onProgress?.call(0.8);

      final videoPath = "${directory.path}/$filename.mp4";
      
      // Ensure dimensions are even numbers (required by many video encoders)
      int videoWidth = canvasSize.width.toInt();
      int videoHeight = canvasSize.height.toInt();
      if (videoWidth % 2 != 0) videoWidth++;
      if (videoHeight % 2 != 0) videoHeight++;

      // Call Native Method Channel
      await _channel.invokeMethod('createVideoFromImages', {
        'imagePaths': framePaths,
        'outputPath': videoPath,
        'fps': 30,
        'width': videoWidth,
        'height': videoHeight,
      });
      
      final videoFile = File(videoPath);
      
      // Save to Gallery
      await Gal.putVideo(videoPath);
      
      onProgress?.call(1.0);

      // Clean up frames
      await _robustDirectoryCleanup(framesDir);

      return videoFile;
    } catch (e) {
      print("Failed to export video: $e");
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

  static Future<void> _robustDirectoryCleanup(Directory dir) async {
    if (!await dir.exists()) return;
    try {
      await dir.delete(recursive: true);
    } catch (e) {
      debugPrint("Initial delete failed: $e. Trying to delete children individually.");
      try {
        if (await dir.exists()) {
          await for (final entity in dir.list(followLinks: false)) {
            try {
              await entity.delete(recursive: true);
            } catch (e) {
              debugPrint("Failed to delete ${entity.path}: $e");
            }
          }
          await dir.delete();
        }
      } catch (e) {
        debugPrint("Failed to clean up directory ${dir.path}: $e");
      }
    }
  }
}