import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/widgets/dialog/background_dialog_picker.dart';

class ToolButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, viewmodel, _) {
        return _buildSectionCard(
          title: "Tools",
          icon: Icons.build,
          child: Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  icon: viewmodel.isEraser ? Icons.brush : Icons.auto_fix_high,
                  label: viewmodel.isEraser ? "Brush" : "Eraser",
                  isActive: viewmodel.isEraser,
                  onPressed: viewmodel.toggleEraser,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildToolButton(
                  icon: Icons.format_color_fill,
                  label: "Background",
                  isActive: false,
                  onPressed: () => _showBackgroundColorPicker(context, viewmodel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Color(0xFF667EEA)),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  )
                : null,
            color: isActive ? null : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Color(0xFF2D3436),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Color(0xFF2D3436),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBackgroundColorPicker(BuildContext context, DrawingViewmodel viewmodel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BackgroundColorPicker(viewmodel: viewmodel),
    );
  }
}
