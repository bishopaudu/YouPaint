🎨 YouPaint

YouPaint is a modern Flutter drawing application that allows users to freely sketch on a canvas, customize brush settings, replay their drawing process, and save their artwork locally.
It is built with clean architecture, smooth animations, and a focus on great UX.

✨ Features

🖌 Freehand Drawing
Draw smoothly on a responsive canvas using touch gestures.

🎨 Color Palette
Select brush colors with animated feedback.

📏 Brush Settings
Adjust brush size dynamically while drawing.

🧰 Tool Selection
Switch between tools (e.g., brush, eraser) with subtle animations.

⏯ Drawing Replay
Replay the entire drawing process as a time-based animation.

💾 Save Artwork
Export your drawing as a PNG image and store it locally on the device.

🧲 Draggable Tool Panel
Tools are placed inside a draggable bottom sheet to keep the canvas centered and distraction-free.

🖼 Screenshots

Replace these image URLs with your actual screenshots.

Home / Canvas	Tools Panel Open	Replay Example

<img width="1290" height="2796" alt="simulator_screenshot_7C0464D2-CE05-492A-AC6F-098F3A3FECC2" src="https://github.com/user-attachments/assets/b9c9f4e9-bf8b-4136-b365-80aaad5eb24e" />

	
	
🧠 Architecture & Design

YouPaint follows a clean and scalable structure:

MVVM (Model–View–ViewModel) pattern

Provider for state management

UI broken into small, reusable widgets

Drawing logic separated from presentation

Canvas rendering handled with CustomPainter

This makes the app easy to maintain, test, and extend.

🛠 Tech Stack

Flutter

Dart

Provider (state management)

CustomPainter (canvas rendering)

Path Provider (local file storage)

📁 Project Structure (Simplified)
lib/
├── models/
│   └── draw_action_model.dart
├── viewmodel/
│   └── drawing_viewmodel.dart
├── widgets/
│   ├── draw_canvas.dart
│   ├── color_palette.dart
│   ├── brush_settings.dart
│   ├── tools_buttons.dart
│   └── appbar_actions.dart
├── view/
│   └── drawing_screen.dart
└── main.dart

🚀 Getting Started
Prerequisites

Flutter SDK installed

Android Studio / VS Code

Android or iOS emulator (or physical device)

Run the app
flutter pub get
flutter run

🔮 Planned Improvements

Undo / Redo support

Multiple brush types

Zoom & pan canvas

Layers support

Cloud sync (Firebase / Supabase)

AI-assisted drawing features (auto-color, shape detection)

🎯 Why This Project?

YouPaint was built to:

Explore canvas rendering in Flutter

Practice clean architecture and state management

Design a realistic, product-level UI

Serve as a portfolio project demonstrating Flutter fundamentals and UX polish

🤝 Contributions

Contributions, ideas, and feedback are welcome.
Feel free to open an issue or submit a pull request.

📄 License

This project is licensed under the MIT License.
