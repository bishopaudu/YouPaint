import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/widgets/appbar_actions.dart';
import 'package:youpaint/widgets/brush_settings.dart';
import 'package:youpaint/widgets/color_palette.dart';
import 'package:youpaint/widgets/custom_app_icon.dart';
import 'package:youpaint/widgets/draw_canvas.dart';
import 'package:youpaint/widgets/tools_buttons.dart';

class DrawingScreen extends StatelessWidget {
  DrawingScreen({super.key});

  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingViewmodel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: _buildAppBarTitle(),
          actions: [
            AppBarActions(repaintKey: _repaintKey),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  // 🎨 App bar title
  Widget _buildAppBarTitle() {
    return Row(
      children: [
      CustomAppIcon(),
        const SizedBox(width: 12),
        const Text(
          "YouPaint",
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  // 🧠 Main layout
  Widget _buildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 🎨 CANVAS (CENTERED)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:10),
          child: DrawingCanvas(
            repaintKey: _repaintKey,
            height: screenHeight * 0.55,
          ),
        ),

        // 🧰 TOOLS BOTTOM SHEET
        _buildToolsBottomSheet(),
      ],
    );
  }

  // 🧰 Draggable tools panel
  Widget _buildToolsBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.12, // collapsed
      minChildSize: 0.12,
      maxChildSize: 0.45, // expanded
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 👆 drag handle
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),

                // 🎨 tools
                ColorPaletteWidget(),
                const SizedBox(height: 16),
                 ToolButtonsWidget(),
                const SizedBox(height: 16),
                BrushSettingsWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
