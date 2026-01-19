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

      /*  await ExportService.exportReplayAsVideo(
          service.points,
          service.backgroundColor,
          filename,
          size,
        );*/

        _showSuccessSnackbar(
          context,
          "Video export initiated! (Note: Full MP4 encoding requires FFmpeg integration)",
        );
      } else {
        await ExportService.exportAsPNG(repaintKey, filename);
        _showSuccessSnackbar(context, "Drawing saved as PNG successfully!");
      }
    } catch (e) {
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