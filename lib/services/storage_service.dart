import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/saved_drawing_model.dart';
import '../models/drawaction_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'youpaint.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drawings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            filePath TEXT NOT NULL,
            thumbnailPath TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Get app directory for saving drawings
  Future<String> get _drawingsDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final drawingsDir = Directory(path.join(appDir.path, 'drawings'));
    if (!await drawingsDir.exists()) {
      await drawingsDir.create(recursive: true);
    }
    return drawingsDir.path;
  }

  // Get thumbnails directory
  Future<String> get _thumbnailsDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbnailsDir = Directory(path.join(appDir.path, 'thumbnails'));
    if (!await thumbnailsDir.exists()) {
      await thumbnailsDir.create(recursive: true);
    }
    return thumbnailsDir.path;
  }

  // Generate thumbnail from drawing
  Future<String> _generateThumbnail(
    List<DrawAction?> strokes,
    Size canvasSize,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw white background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height),
      Paint()..color = Colors.white,
    );

    // Draw all strokes
    for (int i = 0; i < strokes.length - 1; i++) {
      if (strokes[i] != null && strokes[i + 1] != null) {
        final paint = Paint()
          ..color = strokes[i]!.color
          ..strokeWidth = strokes[i]!.size.width
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(strokes[i]!.position, strokes[i + 1]!.position, paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );

    // Create thumbnail (scaled down version)
    final thumbnailRecorder = ui.PictureRecorder();
    final thumbnailCanvas = Canvas(thumbnailRecorder);
    const thumbnailSize = 300.0;
    final scale = thumbnailSize / canvasSize.width.toDouble();

    thumbnailCanvas.scale(scale);
    thumbnailCanvas.drawImage(img, Offset.zero, Paint());

    final thumbnailPicture = thumbnailRecorder.endRecording();
    final thumbnailImg = await thumbnailPicture.toImage(
      thumbnailSize.toInt(),
      (canvasSize.height * scale).toInt(),
    );

    final byteData = await thumbnailImg.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final buffer = byteData!.buffer.asUint8List();

    // Save thumbnail
    final thumbnailsDir = await _thumbnailsDirectory;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final thumbnailPath = path.join(thumbnailsDir, 'thumb_$timestamp.png');
    final thumbnailFile = File(thumbnailPath);
    await thumbnailFile.writeAsBytes(buffer);

    return thumbnailPath;
  }

  // Save drawing with metadata
  Future<SavedDrawingModel> saveDrawing({
    required String title,
    required List<DrawAction?> strokes,
    required Size canvasSize,
    required File drawingFile,
  }) async {
    final db = await database;
    final drawingsDir = await _drawingsDirectory;

    // Copy drawing file to app directory
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newFilePath = path.join(drawingsDir, 'drawing_$timestamp.png');
    await drawingFile.copy(newFilePath);

    // Generate thumbnail
    final thumbnailPath = await _generateThumbnail(strokes, canvasSize);

    // Create model
    final now = DateTime.now();
    final drawing = SavedDrawingModel(
      title: title,
      filePath: newFilePath,
      thumbnailPath: thumbnailPath,
      createdAt: now,
      updatedAt: now,
    );

    // Save to database
    final id = await db.insert('drawings', drawing.toMap());

    return drawing.copyWith(id: id);
  }

  // Get all saved drawings
  Future<List<SavedDrawingModel>> getAllDrawings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'drawings',
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return SavedDrawingModel.fromMap(maps[i]);
    });
  }

  // Get drawing by ID
  Future<SavedDrawingModel?> getDrawingById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'drawings',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return SavedDrawingModel.fromMap(maps[0]);
  }

  // Update drawing
  Future<void> updateDrawing(SavedDrawingModel drawing) async {
    final db = await database;
    await db.update(
      'drawings',
      drawing.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [drawing.id],
    );
  }

  // Delete drawing
  Future<void> deleteDrawing(int id) async {
    final db = await database;

    // Get drawing to delete files
    final drawing = await getDrawingById(id);
    if (drawing != null) {
      // Delete drawing file
      final drawingFile = File(drawing.filePath);
      if (await drawingFile.exists()) {
        await drawingFile.delete();
      }

      // Delete thumbnail file
      final thumbnailFile = File(drawing.thumbnailPath);
      if (await thumbnailFile.exists()) {
        await thumbnailFile.delete();
      }
    }

    // Delete from database
    await db.delete('drawings', where: 'id = ?', whereArgs: [id]);
  }

  // Search drawings by title
  Future<List<SavedDrawingModel>> searchDrawings(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'drawings',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return SavedDrawingModel.fromMap(maps[i]);
    });
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
