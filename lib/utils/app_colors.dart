import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors
  static const Color primaryPurple = Color(0xFF667EEA);
  static const Color primaryBlue = Color(0xFF764BA2);

  // Accent colors
  static const Color accentPink = Color(0xFFF093FB);
  static const Color accentOrange = Color(0xFFF5576C);
  static const Color accentGreen = Color(0xFF4FACFE);
  static const Color accentYellow = Color(0xFFFEDA75);

  // Background colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF16213E);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);

  // Drawing colors palette
  static const List<Color> drawingColors = [
    Color(0xFF000000), // Black
    Color(0xFFFFFFFF), // White
    Color(0xFFFF0000), // Red
    Color(0xFF00FF00), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFFFFFF00), // Yellow
    Color(0xFFFF00FF), // Magenta
    Color(0xFF00FFFF), // Cyan
    Color(0xFFFF8800), // Orange
    Color(0xFF8800FF), // Purple
    Color(0xFF00FF88), // Spring Green
    Color(0xFFFF0088), // Deep Pink
    Color(0xFF88FF00), // Chartreuse
    Color(0xFF0088FF), // Azure
    Color(0xFF8B4513), // Saddle Brown
    Color(0xFF808080), // Gray
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentPink, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [accentGreen, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [accentYellow, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism colors
  static Color glassLight = Colors.white.withOpacity(0.2);
  static Color glassDark = Colors.black.withOpacity(0.2);

  // Shadow colors
  static Color shadowLight = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.3);
}
