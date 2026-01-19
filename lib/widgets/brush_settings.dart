// ==================== widgets/brush_settings.dart ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';

class BrushSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewmodel>(
      builder: (context, service, _) {
        return _buildSectionCard(
          title: "Brush Settings",
          icon: Icons.tune,
          child: Column(
            children: [
              _buildSliderControl(
                label: "Size",
                value: service.brushSize,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                icon: Icons.line_weight,
                onChanged: service.setBrushSize,
              ),
              SizedBox(height: 16),
              _buildSliderControl(
                label: "Opacity",
                value: service.opacity,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                icon: Icons.opacity,
                isPercentage: true,
                onChanged: service.setOpacity,
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

  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
    bool isPercentage = false,
  }) {
    String displayValue =
        isPercentage ? "${(value * 100).round()}%" : value.round().toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Color(0xFF667EEA)),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF636E72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayValue,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667EEA),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Color(0xFF667EEA),
            inactiveTrackColor: Color(0xFFE0E0E0),
            thumbColor: Color(0xFF667EEA),
            overlayColor: Color(0xFF667EEA).withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
