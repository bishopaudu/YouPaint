import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/utils/app_colors.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/widgets/draw_canvas.dart';
import 'package:youpaint/services/share_service.dart';
import 'package:youpaint/view/gallery_screen.dart';
import 'package:youpaint/widgets/dialog/export_dialog.dart';
import 'package:youpaint/services/export_services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class DrawingScreen extends StatefulWidget {
  final int? savedDrawingId;

  const DrawingScreen({super.key, this.savedDrawingId});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  final ShareService _shareService = ShareService();
  bool _showTools = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPurple.withOpacity(0.1),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Main Canvas Area
                  Column(
                    children: [
                      // Top App Bar
                      _buildTopBar(context, viewmodel),

                      // Canvas
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DrawingCanvas(
                              repaintKey: _repaintKey,
                              height: MediaQuery.of(context).size.height * 0.7,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Action Bar
                      _buildBottomActionBar(context, viewmodel),
                    ],
                  ),

                  // Floating Tools Panel
                  if (_showTools) _buildFloatingToolsPanel(context, viewmodel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, DrawingViewmodel viewmodel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textLight.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primaryPurple,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'YouPaint',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Gallery Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GalleryScreen()),
              );
            },
            icon: const Icon(Icons.photo_library_rounded),
            color: AppColors.accentGreen,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'My Gallery',
          ),
          const SizedBox(width: 8),
          // Replay Button
          IconButton(
            onPressed: viewmodel.isReplaying
                ? null
                : () => viewmodel.replayDrawing(),
            icon: const Icon(Icons.play_arrow_rounded),
            color: viewmodel.isReplaying
                ? AppColors.textSecondary
                : AppColors.accentGreen,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Replay Drawing',
          ),
          const SizedBox(width: 8),
          // Undo
          IconButton(
            onPressed: viewmodel.canUndo ? viewmodel.undo : null,
            icon: const Icon(Icons.undo_rounded),
            color: viewmodel.canUndo
                ? AppColors.primaryPurple
                : AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Redo
          IconButton(
            onPressed: viewmodel.canRedo ? viewmodel.redo : null,
            icon: const Icon(Icons.redo_rounded),
            color: viewmodel.canRedo
                ? AppColors.primaryPurple
                : AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Clear
          IconButton(
            onPressed: () => _showClearDialog(context, viewmodel),
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.accentOrange,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.textLight.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tools Button
          Expanded(
            child: _buildActionButton(
              icon: Icons.palette_rounded,
              label: 'Tools',
              gradient: AppColors.primaryGradient,
              onTap: () {
                setState(() {
                  _showTools = !_showTools;
                });
              },
            ),
          ),

          const SizedBox(width: 4),

          // Save Button
          Expanded(
            child: _buildActionButton(
              icon: Icons.save_rounded,
              label: 'Save',
              gradient: AppColors.accentGradient,
              onTap: () => _showSaveDialog(context, viewmodel),
            ),
          ),

          const SizedBox(width: 4),

          // Export Button (Video/Image)
          Expanded(
            child: _buildActionButton(
              icon: Icons.file_download_rounded,
              label: 'Export',
              gradient: AppColors.warmGradient,
              onTap: () => _showExportDialog(context, viewmodel),
            ),
          ),

          const SizedBox(width: 4),

          // Share Button
          Expanded(
            child: _buildActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              gradient: AppColors.coolGradient,
              onTap: () => _shareDrawing(context, viewmodel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textLight, size: 18),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingToolsPanel(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 100,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.textLight.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drawing Tools',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showTools = false;
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color Palette
            Text(
              'Colors',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildColorPalette(viewmodel),
            const SizedBox(height: 20),

            // Brush Size
            Text(
              'Brush Size: ${viewmodel.brushSize.toInt()}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primaryPurple,
                inactiveTrackColor: AppColors.primaryPurple.withOpacity(0.3),
                thumbColor: AppColors.primaryPurple,
                overlayColor: AppColors.primaryPurple.withOpacity(0.2),
              ),
              child: Slider(
                value: viewmodel.brushSize,
                min: 1,
                max: 50,
                onChanged: (value) {
                  viewmodel.setBrushSize(value);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tools
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolButton(
                  icon: Icons.brush_rounded,
                  label: 'Brush',
                  isSelected: !viewmodel.isEraser,
                  onTap: () {
                    if (viewmodel.isEraser) {
                      viewmodel.toggleEraser();
                    }
                  },
                ),
                _buildToolButton(
                  icon: Icons.auto_fix_high_rounded,
                  label: 'Eraser',
                  isSelected: viewmodel.isEraser,
                  onTap: viewmodel.toggleEraser,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPalette(DrawingViewmodel viewmodel) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AppColors.drawingColors.map((color) {
        final isSelected = viewmodel.selectedColor == color;
        return GestureDetector(
          onTap: () => viewmodel.setColor(color),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryPurple
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.textLight : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textLight : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSaveDialog(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) async {
    if (!viewmodel.hasDrawing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to save! Start drawing first.')),
      );
      return;
    }

    final titleController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Drawing'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Enter drawing title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      try {
        await viewmodel.saveDrawing(
          title: titleController.text,
          canvasKey: _repaintKey,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Drawing saved successfully!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
        }
      }
    }
  }

  Future<void> _shareDrawing(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) async {
    if (!viewmodel.hasDrawing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to share! Start drawing first.')),
      );
      return;
    }

    try {
      // Capture canvas as image
      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/share_$timestamp.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Share
      await _shareService.shareImage(
        imageFile: tempFile,
        title: 'My YouPaint Drawing',
      );

      // Clean up
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    }
  }

  Future<void> _showClearDialog(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text(
          'Are you sure you want to clear the canvas? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (result == true) {
      viewmodel.clear();
    }
  }

  Future<void> _showExportDialog(
    BuildContext context,
    DrawingViewmodel viewmodel,
  ) async {
    if (!viewmodel.hasDrawing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to export! Start drawing first.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => ExportDialog(
        onExport: (filename, isVideo) =>
            _handleExport(context, viewmodel, filename, isVideo),
      ),
    );
  }

  Future<void> _handleExport(
    BuildContext context,
    DrawingViewmodel viewmodel,
    String filename,
    bool isVideo,
  ) async {
    try {
      if (isVideo) {
        // Get canvas size from repaint boundary
        final RenderBox? renderBox =
            _repaintKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? const Size(400, 450);

        // Show Progress Dialog
        final progressNotifier = ValueNotifier<double>(0.0);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _LoadingDialog(
            progressNotifier: progressNotifier,
            message: "Generating Video...",
          ),
        );

        await ExportService.exportReplayAsVideo(
          viewmodel.points,
          viewmodel.backgroundColor,
          filename,
          size,
          onProgress: (progress) {
            progressNotifier.value = progress;
          },
        );

        // Close Dialog
        if (context.mounted) Navigator.pop(context);

        if (context.mounted) {
          _showSuccessSnackbar(
            context,
            "Video exported successfully to Gallery!",
          );
        }
      } else {
        await ExportService.exportAsPNG(_repaintKey, filename);
        if (context.mounted) {
          _showSuccessSnackbar(context, "Drawing saved as PNG successfully!");
        }
      }
    } catch (e) {
      // Close Dialog if open
      if (isVideo && context.mounted) Navigator.pop(context);

      if (context.mounted) {
        _showErrorSnackbar(context, "Export failed: $e");
      }
    }
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.accentOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ==================== Loading Dialog ====================
class _LoadingDialog extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;
  final String message;

  const _LoadingDialog({required this.progressNotifier, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.textLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Determine status text
              Text(
                value >= 0.8 ? "Encoding Video..." : "Generating Frames...",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              if (value >= 0.8)
                CircularProgressIndicator(color: AppColors.primaryPurple)
              else
                LinearProgressIndicator(
                  value: value / 0.8, // Normalize 0.0-0.8 to 0.0-1.0
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),

              const SizedBox(height: 10),
              if (value < 0.8)
                Text(
                  "${((value / 0.8) * 100).toInt()}%",
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          );
        },
      ),
    );
  }
}
