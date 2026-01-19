import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';

class ColorPaletteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, service, _) {
        return _buildSectionCard(
          title: "Colors",
          icon: Icons.palette,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: service.colorPalette
                .map((color) => _buildColorPicker(service, color))
                .toList(),
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

  Widget _buildColorPicker(DrawingViewmodel viewmodel, Color color) {
    bool isSelected = viewmodel.selectedColor == color && !viewmodel.isEraser;
    return GestureDetector(
      onTap: () => viewmodel.setColor(color),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Color(0xFF667EEA) : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.4)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isSelected ? Icon(Icons.check, color: Colors.white, size: 24) : null,
      ),
    );
  }
}