// ==================== widgets/dialogs/background_color_picker.dart ====================
import 'package:flutter/material.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';

class BackgroundColorPicker extends StatelessWidget {
  final DrawingViewmodel viewmodel;

  const BackgroundColorPicker({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_color_fill, color: Color(0xFF667EEA)),
              SizedBox(width: 12),
              Text(
                "Choose Background Color",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: viewmodel.backgroundColors.map((color) {
              bool isSelected = viewmodel.backgroundColor == color;
              return GestureDetector(
                onTap: () {
                  viewmodel.setBackgroundColor(color);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFF667EEA)
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          size: 28,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}