import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getTheme(String themeId) {
    final ColorScheme scheme = AppColors.themeSchemes[themeId] ?? AppColors.themeSchemes['Default Blue']!;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          height: 1.2,
          color: scheme.onSurface,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.2,
          color: scheme.onSurface,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.5,
          color: scheme.onSurface,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: scheme.outlineVariant,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => getTheme('Default Blue');
}

