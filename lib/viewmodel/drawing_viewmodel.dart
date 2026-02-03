import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';
import 'package:youpaint/models/saved_drawing_model.dart';
import 'package:youpaint/services/storage_service.dart';

class DrawingViewmodel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<DrawAction?> _points = [];
  List<DrawAction?> _replayedPoints = [];
  List<List<DrawAction?>> _history = [];
  int _historyIndex = -1;
  int? _currentDrawingId; // Track if we're editing an existing drawing

  Color _selectedColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  double _brushSize = 5.0;
  double _opacity = 1.0;
  bool _isEraser = false;
  bool _isReplaying = false;

  // Getters
  List<DrawAction?> get points => _points;
  List<DrawAction?> get replayedPoints => _replayedPoints;
  Color get selectedColor => _selectedColor;
  Color get backgroundColor => _backgroundColor;
  double get brushSize => _brushSize;
  double get opacity => _opacity;
  bool get isEraser => _isEraser;
  bool get isReplaying => _isReplaying;
  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;
  int? get currentDrawingId => _currentDrawingId;
  bool get hasDrawing => _points.isNotEmpty;

  // Color palettes
  final List<Color> colorPalette = [
    Color(0xFF000000), // Black
    Color(0xFF4A90E2), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF795548), // Brown
  ];

  final List<Color> backgroundColors = [
    Colors.white,
    Color(0xFFF5F5F5),
    Color(0xFFE3F2FD),
    Color(0xFFFFF3E0),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFF263238),
    Color(0xFF1A1A1A),
  ];

  void addPoint(DrawAction? action) {
    _points.add(action);
    notifyListeners();
  }

  void setColor(Color color) {
    _selectedColor = color;
    _isEraser = false;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setBrushSize(double size) {
    _brushSize = size;
    notifyListeners();
  }

  void setOpacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }

  void toggleEraser() {
    _isEraser = !_isEraser;
    notifyListeners();
  }

  void saveToHistory() {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(List.from(_points));
    _historyIndex = _history.length - 1;

    if (_history.length > 50) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  void undo() {
    if (canUndo) {
      _historyIndex--;
      _points = List.from(_history[_historyIndex]);
      _replayedPoints.clear();
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _historyIndex++;
      _points = List.from(_history[_historyIndex]);
      _replayedPoints.clear();
      notifyListeners();
    }
  }

  void clear() {
    saveToHistory();
    _points.clear();
    _replayedPoints.clear();
    notifyListeners();
  }

  // Create a new blank canvas
  void newDrawing() {
    _points.clear();
    _replayedPoints.clear();
    _history.clear();
    _historyIndex = -1;
    _currentDrawingId = null;
    _backgroundColor = Colors.white;
    _selectedColor = Colors.blue;
    _brushSize = 5.0;
    _opacity = 1.0;
    _isEraser = false;
    notifyListeners();
  }

  // Load a saved drawing
  Future<void> loadDrawing(SavedDrawingModel drawing) async {
    // For now, we'll just set the drawing ID
    // In a full implementation, you'd load the actual drawing data
    _currentDrawingId = drawing.id;
    // TODO: Load actual drawing points from file
    notifyListeners();
  }

  // Save current drawing
  Future<SavedDrawingModel?> saveDrawing({
    required String title,
    required GlobalKey canvasKey,
  }) async {
    try {
      // Capture the canvas as an image
      final boundary =
          canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Canvas not found');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/drawing_$timestamp.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Get canvas size
      final size = boundary.size;

      // Save using storage service
      final savedDrawing = await _storageService.saveDrawing(
        title: title,
        strokes: _points,
        canvasSize: size,
        drawingFile: tempFile,
      );

      _currentDrawingId = savedDrawing.id;

      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      return savedDrawing;
    } catch (e) {
      debugPrint('Error saving drawing: $e');
      rethrow;
    }
  }

  Future<void> replayDrawing() async {
    if (_points.isEmpty) return;

    _isReplaying = true;
    _replayedPoints.clear();
    notifyListeners();

    for (int i = 0; i < _points.length; i++) {
      if (_points[i] != null) {
        _replayedPoints.add(_points[i]);
        await Future.delayed(Duration(milliseconds: _calculateDelay(i)));
      } else {
        _replayedPoints.add(null);
      }
      notifyListeners();
    }

    _isReplaying = false;
    notifyListeners();
  }

  int _calculateDelay(int index) {
    if (index == 0 || _points[index - 1] == null || _points[index] == null) {
      return 16;
    }

    final prevTimestamp = _points[index - 1]?.timestamp ?? DateTime.now();
    final currentTimestamp = _points[index]?.timestamp ?? DateTime.now();
    return currentTimestamp
        .difference(prevTimestamp)
        .inMilliseconds
        .clamp(16, 100);
  }
}
