import 'package:flutter/material.dart';
import '../models/saved_drawing_model.dart';
import '../services/storage_service.dart';

class GalleryViewmodel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<SavedDrawingModel> _drawings = [];
  List<SavedDrawingModel> _filteredDrawings = [];
  bool _isLoading = false;
  String _searchQuery = '';

  // Getters
  List<SavedDrawingModel> get drawings => _filteredDrawings;
  bool get isLoading => _isLoading;
  bool get hasDrawings => _drawings.isNotEmpty;
  String get searchQuery => _searchQuery;

  // Load all drawings
  Future<void> loadDrawings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _drawings = await _storageService.getAllDrawings();
      _filteredDrawings = List.from(_drawings);
    } catch (e) {
      debugPrint('Error loading drawings: $e');
      _drawings = [];
      _filteredDrawings = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh drawings
  Future<void> refreshDrawings() async {
    await loadDrawings();
  }

  // Delete a drawing
  Future<void> deleteDrawing(int id) async {
    try {
      await _storageService.deleteDrawing(id);
      await loadDrawings();
    } catch (e) {
      debugPrint('Error deleting drawing: $e');
      rethrow;
    }
  }

  // Search drawings
  void searchDrawings(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredDrawings = List.from(_drawings);
    } else {
      _filteredDrawings = _drawings
          .where(
            (drawing) =>
                drawing.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredDrawings = List.from(_drawings);
    notifyListeners();
  }

  // Get drawing by ID
  SavedDrawingModel? getDrawingById(int id) {
    try {
      return _drawings.firstWhere((drawing) => drawing.id == id);
    } catch (e) {
      return null;
    }
  }
}
