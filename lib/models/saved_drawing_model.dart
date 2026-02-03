class SavedDrawingModel {
  final int? id;
  final String title;
  final String filePath;
  final String thumbnailPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedDrawingModel({
    this.id,
    required this.title,
    required this.filePath,
    required this.thumbnailPath,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (database retrieval)
  factory SavedDrawingModel.fromMap(Map<String, dynamic> map) {
    return SavedDrawingModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      filePath: map['filePath'] as String,
      thumbnailPath: map['thumbnailPath'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  // Create a copy with updated fields
  SavedDrawingModel copyWith({
    int? id,
    String? title,
    String? filePath,
    String? thumbnailPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedDrawingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SavedDrawingModel(id: $id, title: $title, filePath: $filePath, thumbnailPath: $thumbnailPath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
