// ==================== widgets/app_bar_actions.dart ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/services/export_services.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/widgets/dialog/clear_confirmation_dialog.dart';
import 'package:youpaint/widgets/dialog/export_dialog.dart';


class AppBarActions extends StatelessWidget {
  final GlobalKey repaintKey;

  const AppBarActions({Key? key, required this.repaintKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, service, _) {
        return Row(
          children: [
            _buildIconButton(
              context,
              icon: Icons.undo,
              onPressed: service.canUndo ? service.undo : null,
              tooltip: "Undo",
            ),
            _buildIconButton(
              context,
              icon: Icons.redo,
              onPressed: service.canRedo ? service.redo : null,
              tooltip: "Redo",
            ),
            _buildIconButton(
              context,
              icon: Icons.delete_outline,
              onPressed: () => _showClearDialog(context, service),
              tooltip: "Clear Canvas",
            ),
            _buildIconButton(
              context,
              icon: Icons.play_arrow,
              onPressed: service.isReplaying ? null : service.replayDrawing,
              tooltip: "Replay Drawing",
            ),
            _buildIconButton(
              context,
              icon: Icons.save_alt,
              onPressed: () => _showExportDialog(context, service),
              tooltip: "Export Drawing",
            ),
            SizedBox(width: 8),
          ],
        );
      },
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: onPressed != null ? Color(0xFF2D3436) : Colors.grey.shade400,
        splashRadius: 20,
      ),
    );
  }

  void _showClearDialog(BuildContext context, DrawingViewmodel viewmodel) {
    showDialog(
      context: context,
      builder: (_) => ClearConfirmationDialog(onConfirm: viewmodel.clear),
    );
  }

  void _showExportDialog(BuildContext context, DrawingViewmodel viewmodel) {
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
            repaintKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size(400, 450);

        // Show Progress Dialog
        final progressNotifier = ValueNotifier<double>(0.0);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LoadingDialog(
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
        Navigator.pop(context);

        _showSuccessSnackbar(
          context,
          "Video exported successfully to Gallery!",
        );
      } else {
        await ExportService.exportAsPNG(repaintKey, filename);
        _showSuccessSnackbar(context, "Drawing saved as PNG successfully!");
      }
    } catch (e) {
      // Close Dialog if open (check if context is valid/mounted if needed, but simple pop is safeish here)
       if (isVideo) Navigator.pop(context);
       
      _showErrorSnackbar(context, "Export failed: $e");
    }
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFF2ECC71),
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
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ==================== Loading Dialog ====================
class LoadingDialog extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;
  final String message;

  const LoadingDialog({
    Key? key,
    required this.progressNotifier,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              // Determine status text
              Text(
                value >= 0.8 ? "Encoding Video..." : "Generating Frames...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 20),
              
              if (value >= 0.8) 
                 CircularProgressIndicator(color: Color(0xFF667EEA))
              else
                 LinearProgressIndicator(
                  value: value / 0.8, // Normalize 0.0-0.8 to 0.0-1.0
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                
              SizedBox(height: 10),
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