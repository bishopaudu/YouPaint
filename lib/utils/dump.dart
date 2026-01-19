/*import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<DrawAction?> points = []; // Store the original points with timestamps
  List<DrawAction?> replayedPoints = []; // Points to display during replay
  Color selectedColor = Colors.blue; // Default brush color
  bool isReplaying = false; // To track if replay is ongoing
  double brushSize = 5.0;
  GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text("Youpaint"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear(); // Clear the drawing
                replayedPoints.clear(); // Also clear the replayed points
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: isReplaying
                ? null
                : _replayDrawing, // Disable button during replay
          ),
           IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDrawing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Simple color picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildColorPicker(Colors.blue),
                _buildColorPicker(Colors.red),
                _buildColorPicker(Colors.green),
                _buildColorPicker(Colors.yellow),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Slider(
                  value: brushSize.toDouble(),
                  min: 1.0,
                  max: 10.0,
                  divisions: 19,
                  label: "${brushSize.round()}",
                  onChanged: (value) {
                    setState(() {
                      brushSize = value;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(DrawAction(
                          position: details.localPosition,
                          timestamp: DateTime.now(),
                          color: selectedColor,
                          size: Size(brushSize, brushSize),
                        ));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points
                            .add(null); // Add null to indicate lifting the finger
                      });
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(
                        isReplaying ? replayedPoints : points,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
      ),
    );
  }

  Future _saveDrawing() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  //final imagePath = await ImageGallerySaver.saveImage(pngBytes);
  final directory= await getApplicationDocumentsDirectory();
  final filePath = "${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png";
  final file = File(filePath);
      await file.writeAsBytes(pngBytes);
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Drawing saved successfully!")),
      );

    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save drawing.")),
      );
    }

  }
 

  Future<void> _replayDrawing() async {
    if (points.isEmpty) return;

    setState(() {
      isReplaying = true;
      replayedPoints.clear(); // Clear replayedPoints before replay starts
    });

    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        replayedPoints.add(points[i]);
        await Future.delayed(Duration(milliseconds: _calculateDelay(i)));
      } else {
        replayedPoints.add(null); // Add null to simulate a break in the drawing
      }

      setState(() {}); // Trigger a rebuild to update the canvas
    }

    setState(() {
      isReplaying = false;
    });
  }

  int _calculateDelay(int index) {
    if (index == 0 || points[index - 1] == null || points[index] == null) {
      return 16; // Default frame rate delay
    }

    final prevTimestamp = points[index - 1]?.timestamp ?? DateTime.now();
    final currentTimestamp = points[index]?.timestamp ?? DateTime.now();
    return currentTimestamp
        .difference(prevTimestamp)
        .inMilliseconds
        .clamp(16, 100);
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawAction?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        final paint = Paint()
          ..color = current.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;

        canvas.drawLine(current.position, next.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/

/*import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<DrawAction?> points = [];
  List<DrawAction?> replayedPoints = [];
  
  // ✨ NEW: Added more state variables
  Color selectedColor = Colors.blue;
  Color backgroundColor = Colors.grey.shade300; // NEW: Background color
  bool isReplaying = false;
  double brushSize = 5.0;
  double opacity = 1.0; // NEW: Opacity control (1.0 = fully opaque, 0.0 = transparent)
  bool isEraser = false; // NEW: Eraser mode flag
  
  GlobalKey _repaintKey = GlobalKey();

  // ✨ NEW: Store history for undo/redo
  List<List<DrawAction?>> history = []; // Stores previous states
  int historyIndex = -1; // Current position in history

  // ✨ NEW: Expanded color palette
  final List<Color> colorPalette = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text("Youpaint"),
        actions: [
          // ✨ NEW: Undo button
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: historyIndex > 0 ? _undo : null, // Disabled if nothing to undo
          ),
          // ✨ NEW: Redo button
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: historyIndex < history.length - 1 ? _redo : null,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _saveToHistory(); // Save before clearing
                points.clear();
                replayedPoints.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: isReplaying ? null : _replayDrawing,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDrawing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // ✨ NEW: Expanded color picker with more colors
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: colorPalette.map((color) => _buildColorPicker(color)).toList(),
              ),
            ),

            // ✨ NEW: Eraser toggle button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isEraser = !isEraser; // Toggle eraser mode
                      });
                    },
                    icon: Icon(isEraser ? Icons.brush : Icons.cleaning_services),
                    label: Text(isEraser ? "Brush Mode" : "Eraser Mode"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEraser ? Colors.orange : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ✨ NEW: Background color picker button
                  ElevatedButton.icon(
                    onPressed: _showBackgroundColorPicker,
                    icon: const Icon(Icons.format_paint),
                    label: const Text("Background"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: backgroundColor.computeLuminance() > 0.5 
                          ? Colors.black 
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Brush size slider
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.brush, size: 16),
                  Expanded(
                    child: Slider(
                      value: brushSize,
                      min: 1.0,
                      max: 20.0, // Increased max size
                      divisions: 19,
                      label: "${brushSize.round()}",
                      onChanged: (value) {
                        setState(() {
                          brushSize = value;
                        });
                      },
                    ),
                  ),
                  const Icon(Icons.brush, size: 32),
                ],
              ),
            ),

            // ✨ NEW: Opacity slider
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.opacity, size: 20),
                  Expanded(
                    child: Slider(
                      value: opacity,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      label: "${(opacity * 100).round()}%",
                      onChanged: (value) {
                        setState(() {
                          opacity = value;
                        });
                      },
                    ),
                  ),
                  Text("${(opacity * 100).round()}%"),
                ],
              ),
            ),

            // Drawing canvas
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor, // ✨ NEW: Dynamic background color
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      // ✨ NEW: Save to history when starting a new stroke
                      _saveToHistory();
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(DrawAction(
                          position: details.localPosition,
                          timestamp: DateTime.now(),
                          // ✨ NEW: Use background color for eraser, apply opacity
                          color: isEraser 
                              ? backgroundColor 
                              : selectedColor.withOpacity(opacity),
                          size: Size(brushSize, brushSize),
                        ));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(
                        isReplaying ? replayedPoints : points,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    bool isSelected = selectedColor == color && !isEraser;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          isEraser = false; // Turn off eraser when selecting a color
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected 
              ? Border.all(color: Colors.white, width: 3)
              : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
              : null,
        ),
      ),
    );
  }

  // ✨ NEW: Show background color picker dialog
  void _showBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Background Color"),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Colors.white,
            Colors.grey.shade300,
            Colors.grey.shade700,
            Colors.black,
            Colors.blue.shade100,
            Colors.green.shade100,
            Colors.pink.shade100,
            Colors.yellow.shade100,
          ].map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  backgroundColor = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ✨ NEW: Save current state to history (for undo/redo)
  void _saveToHistory() {
    // Remove any future history if we're not at the end
    if (historyIndex < history.length - 1) {
      history.removeRange(historyIndex + 1, history.length);
    }
    
    // Save current points as a new history entry
    history.add(List.from(points));
    historyIndex = history.length - 1;
    
    // Limit history to 50 states to save memory
    if (history.length > 50) {
      history.removeAt(0);
      historyIndex--;
    }
  }

  // ✨ NEW: Undo function
  void _undo() {
    if (historyIndex > 0) {
      setState(() {
        historyIndex--;
        points = List.from(history[historyIndex]);
        replayedPoints.clear();
      });
    }
  }

  // ✨ NEW: Redo function
  void _redo() {
    if (historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        points = List.from(history[historyIndex]);
        replayedPoints.clear();
      });
    }
  }

  Future _saveDrawing() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png";
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Drawing saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save drawing.")),
      );
    }
  }

  Future<void> _replayDrawing() async {
    if (points.isEmpty) return;

    setState(() {
      isReplaying = true;
      replayedPoints.clear();
    });

    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        replayedPoints.add(points[i]);
        await Future.delayed(Duration(milliseconds: _calculateDelay(i)));
      } else {
        replayedPoints.add(null);
      }

      setState(() {});
    }

    setState(() {
      isReplaying = false;
    });
  }

  int _calculateDelay(int index) {
    if (index == 0 || points[index - 1] == null || points[index] == null) {
      return 16;
    }

    final prevTimestamp = points[index - 1]?.timestamp ?? DateTime.now();
    final currentTimestamp = points[index]?.timestamp ?? DateTime.now();
    return currentTimestamp
        .difference(prevTimestamp)
        .inMilliseconds
        .clamp(16, 100);
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawAction?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        final paint = Paint()
          ..color = current.color // ✨ Now includes opacity from the color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = current.size.width; // ✨ Use stored brush size

        canvas.drawLine(current.position, next.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}*/


/*import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youpaint/models/drawaction_model.dart';

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<DrawAction?> points = [];
  List<DrawAction?> replayedPoints = [];
  
  Color selectedColor = Colors.blue;
  Color backgroundColor = Colors.white;
  bool isReplaying = false;
  double brushSize = 5.0;
  double opacity = 1.0;
  bool isEraser = false;
  
  GlobalKey _repaintKey = GlobalKey();

  List<List<DrawAction?>> history = [];
  int historyIndex = -1;

  final List<Color> colorPalette = [
    Color(0xFF000000), // Black
    Color(0xFF4A90E2), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF795548), // Brown
  ];

  final List<Color> backgroundColors = [
    Colors.white,
    Color(0xFFF5F5F5), // Light gray
    Color(0xFFE3F2FD), // Light blue
    Color(0xFFFFF3E0), // Light orange
    Color(0xFFF3E5F5), // Light purple
    Color(0xFFE8F5E9), // Light green
    Color(0xFF263238), // Dark slate
    Color(0xFF1A1A1A), // Almost black
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.palette, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              "YouPaint",
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          _buildAppBarButton(
            icon: Icons.undo,
            onPressed: historyIndex > 0 ? _undo : null,
            tooltip: "Undo",
          ),
          _buildAppBarButton(
            icon: Icons.redo,
            onPressed: historyIndex < history.length - 1 ? _redo : null,
            tooltip: "Redo",
          ),
          _buildAppBarButton(
            icon: Icons.delete_outline,
            onPressed: () {
              _showClearConfirmation();
            },
            tooltip: "Clear Canvas",
          ),
          _buildAppBarButton(
            icon: Icons.play_arrow,
            onPressed: isReplaying ? null : _replayDrawing,
            tooltip: "Replay Drawing",
          ),
          _buildAppBarButton(
            icon: Icons.save_alt,
            onPressed: _saveDrawing,
            tooltip: "Save Drawing",
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color Palette Section
              _buildSectionCard(
                title: "Colors",
                icon: Icons.palette,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: colorPalette.map((color) => _buildColorPicker(color)).toList(),
                ),
              ),
              
              SizedBox(height: 16),

              // Tools Section
              _buildSectionCard(
                title: "Tools",
                icon: Icons.build,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildToolButton(
                        icon: isEraser ? Icons.brush : Icons.auto_fix_high,
                        label: isEraser ? "Brush" : "Eraser",
                        isActive: isEraser,
                        onPressed: () {
                          setState(() {
                            isEraser = !isEraser;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildToolButton(
                        icon: Icons.format_color_fill,
                        label: "Background",
                        isActive: false,
                        onPressed: _showBackgroundColorPicker,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Brush Settings Section
              _buildSectionCard(
                title: "Brush Settings",
                icon: Icons.tune,
                child: Column(
                  children: [
                    _buildSliderControl(
                      label: "Size",
                      value: brushSize,
                      min: 1.0,
                      max: 20.0,
                      divisions: 19,
                      icon: Icons.line_weight,
                      onChanged: (value) {
                        setState(() {
                          brushSize = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildSliderControl(
                      label: "Opacity",
                      value: opacity,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      icon: Icons.opacity,
                      isPercentage: true,
                      onChanged: (value) {
                        setState(() {
                          opacity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Canvas Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: Container(
                      height: 450,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onPanStart: (details) {
                          _saveToHistory();
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            points.add(DrawAction(
                              position: details.localPosition,
                              timestamp: DateTime.now(),
                              color: isEraser 
                                  ? backgroundColor 
                                  : selectedColor.withOpacity(opacity),
                              size: Size(brushSize, brushSize),
                            ));
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            points.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(
                            isReplaying ? replayedPoints : points,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarButton({
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

  Widget _buildColorPicker(Color color) {
    bool isSelected = selectedColor == color && !isEraser;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          isEraser = false;
        });
      },
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
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 24)
            : null,
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
    String displayValue = isPercentage 
        ? "${(value * 100).round()}%" 
        : value.round().toString();

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

  void _showBackgroundColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              children: backgroundColors.map((color) {
                bool isSelected = backgroundColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      backgroundColor = color;
                    });
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
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text("Clear Canvas?"),
          ],
        ),
        content: Text(
          "This will delete your current drawing. This action cannot be undone.",
          style: TextStyle(color: Color(0xFF636E72)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFF636E72)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _saveToHistory();
                points.clear();
                replayedPoints.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Clear", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveToHistory() {
    if (historyIndex < history.length - 1) {
      history.removeRange(historyIndex + 1, history.length);
    }
    
    history.add(List.from(points));
    historyIndex = history.length - 1;
    
    if (history.length > 50) {
      history.removeAt(0);
      historyIndex--;
    }
  }

  void _undo() {
    if (historyIndex > 0) {
      setState(() {
        historyIndex--;
        points = List.from(history[historyIndex]);
        replayedPoints.clear();
      });
    }
  }

  void _redo() {
    if (historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        points = List.from(history[historyIndex]);
        replayedPoints.clear();
      });
    }
  }

  Future _saveDrawing() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png";
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text("Drawing saved successfully!"),
            ],
          ),
          backgroundColor: Color(0xFF2ECC71),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text("Failed to save drawing."),
            ],
          ),
          backgroundColor: Color(0xFFE74C3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _replayDrawing() async {
    if (points.isEmpty) return;

    setState(() {
      isReplaying = true;
      replayedPoints.clear();
    });

    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        replayedPoints.add(points[i]);
        await Future.delayed(Duration(milliseconds: _calculateDelay(i)));
      } else {
        replayedPoints.add(null);
      }

      setState(() {});
    }

    setState(() {
      isReplaying = false;
    });
  }

  int _calculateDelay(int index) {
    if (index == 0 || points[index - 1] == null || points[index] == null) {
      return 16;
    }

    final prevTimestamp = points[index - 1]?.timestamp ?? DateTime.now();
    final currentTimestamp = points[index]?.timestamp ?? DateTime.now();
    return currentTimestamp
        .difference(prevTimestamp)
        .inMilliseconds
        .clamp(16, 100);
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawAction?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        final paint = Paint()
          ..color = current.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = current.size.width;

        canvas.drawLine(current.position, next.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/widgets/appbar_actions.dart';
import 'package:youpaint/widgets/brush_settings.dart';
import 'package:youpaint/widgets/color_palette.dart';
import 'package:youpaint/widgets/draw_canvas.dart';
import 'package:youpaint/widgets/tools_buttons.dart';


class DrawingScreen extends StatelessWidget {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingViewmodel(),
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: _buildAppBarTitle(),
          actions: [AppBarActions(repaintKey: _repaintKey)],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.palette, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Text(
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

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate canvas size (fixed aspect ratio)
        double canvasHeight = constraints.maxHeight * 0.6;
        double canvasWidth = constraints.maxWidth - 32;

        return Column(
          children: [
            // Controls Section (scrollable if needed)
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ColorPaletteWidget(),
                    SizedBox(height: 16),
                    ToolButtonsWidget(),
                    SizedBox(height: 16),
                    BrushSettingsWidget(),
                  ],
                ),
              ),
            ),

            // Canvas Section (fixed, centered, non-scrollable)
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DrawingCanvas(
                    repaintKey: _repaintKey,
                    height: canvasHeight,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}*/