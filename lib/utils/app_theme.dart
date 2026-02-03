import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryPurple,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryPurple,
      secondary: AppColors.accentPink,
      surface: AppColors.cardLight,
      error: AppColors.accentOrange,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textLight,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 4,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 6,
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: AppColors.textLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryPurple,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryPurple,
      secondary: AppColors.accentPink,
      surface: AppColors.cardDark,
      error: AppColors.accentOrange,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
      onError: AppColors.textLight,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textLight,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textLight,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textLight.withOpacity(0.7),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 4,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 6,
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: AppColors.textLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textLight,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
    ),
  );
}
