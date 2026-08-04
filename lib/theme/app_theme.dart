import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens for the Barangay Community Information System.
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2A8B88); // Professional Teal
  static const Color primaryDark = Color(0xFF1B5A58);
  static const Color navy = Color(0xFF1E2D3E); // Deep Navy for headers/text
  static const Color accent = Color(0xFFF9A826); // Warm Yellow for highlights
  static const Color secondary = accent; // Backward-compatible alias for existing screens

  // Semantic Colors (Alerts & Status)
  static const Color danger = Color(0xFFE63946); 
  static const Color info = Color(0xFF457B9D);
  static const Color success = Color(0xFF2A9D8F);
  
  // Background & Surface
  static const Color background = Color(0xFFF4F7F6); // Soft off-white to reduce visual stress
  static const Color surface = Colors.white;
  
  // Typography
  static const Color textPrimary = Color(0xFF1E2D3E); // Navy instead of harsh black
  static const Color textSecondary = Color(0xFF7A8696);
  static const Color divider = Color(0xFFE2E8F0);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true, 
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),
      
      // Typography: Utilizing Lexend/Inter for high legibility
      textTheme: GoogleFonts.lexendTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.lexend(fontWeight: FontWeight.w700, fontSize: 24, color: AppColors.textPrimary, letterSpacing: -0.5),
        titleMedium: GoogleFonts.lexend(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.lexend(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.lexend(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.lexend(fontWeight: FontWeight.w300, fontSize: 12, color: AppColors.textSecondary),
      ),

      // App Bar Styling
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.navy),
        titleTextStyle: GoogleFonts.lexend(fontWeight: FontWeight.w600, fontSize: 20, color: AppColors.navy),
      ),

      // Card Styling: Softer shadows and rounded corners
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.navy.withValues(alpha: 0.1),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Input Fields: Modern pill-shaped/rounded borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.lexend(color: AppColors.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons: Bold, readable, and highly clickable
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.lexend(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}