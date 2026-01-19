import 'package:flutter/material.dart';
import 'package:youpaint/models/drawaction_model.dart';

class DrawingViewmodel extends ChangeNotifier {
  List<DrawAction?> _points = [];
  List<DrawAction?> _replayedPoints = [];
  List<List<DrawAction?>> _history = [];
  int _historyIndex = -1;

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
    return currentTimestamp.difference(prevTimestamp).inMilliseconds.clamp(16, 100);
  }
}