import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Default Blue - Ocean)
  static const Color primary = Color(0xFF006688);
  static const Color primaryContainer = Color(0xFF40B5E8);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF00445C);

  static const Color secondary = Color(0xFF745C00);
  static const Color secondaryContainer = Color(0xFFFCD03D);
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF705900);

  static const Color tertiary = Color(0xFF006E29);
  static const Color tertiaryContainer = Color(0xFF5DBD6B);
  static const Color onTertiary = Colors.white;
  static const Color onTertiaryContainer = Color(0xFF004919);

  // Depth Colors for 3D buttons
  static const Color primaryDepth = Color(0xFF00445C);
  static const Color secondaryDepth = Color(0xFF4E3D00);
  static const Color tertiaryDepth = Color(0xFF004919);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFFBF9F8);
  static const Color onBackground = Color(0xFF1B1C1C);
  static const Color surface = Color(0xFFFBF9F8);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF3E484F);
  static const Color outline = Color(0xFF6E7880);
  static const Color outlineVariant = Color(0xFFBDC8D0);
  static const Color surfaceContainer = Color(0xFFEFEDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E8);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E2);
  static const Color surfaceContainerLow = Color(0xFFF6F4F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFDDE3EA);

  // Theme Palettes
  static Map<String, ColorScheme> get themeSchemes => {
    'Default Blue': ColorScheme.fromSeed(
      seedColor: const Color(0xFF006688),
      primary: const Color(0xFF006688),
      secondary: const Color(0xFF745C00),
      surface: const Color(0xFFF0F9FF),
      brightness: Brightness.light,
    ),
    'forest': ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      primary: const Color(0xFF2E7D32),
      secondary: const Color(0xFFF9A825),
      surface: const Color(0xFFE8F5E9),
      brightness: Brightness.light,
    ),
    'ocean': ColorScheme.fromSeed(
      seedColor: const Color(0xFF0277BD),
      primary: const Color(0xFF0277BD),
      secondary: const Color(0xFFFFB300),
      surface: const Color(0xFFE1F5FE),
      brightness: Brightness.light,
    ),
    'space': ColorScheme.fromSeed(
      seedColor: const Color(0xFF4527A0),
      primary: const Color(0xFF7E57C2),
      secondary: const Color(0xFFFFD600),
      surface: const Color(0xFF1A1A2E),
      brightness: Brightness.dark,
    ),
    'candy': ColorScheme.fromSeed(
      seedColor: const Color(0xFFD81B60),
      primary: const Color(0xFFEC407A),
      secondary: const Color(0xFF26C6DA),
      surface: const Color(0xFFFFF1F8),
      brightness: Brightness.light,
    ),
  };

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color secondaryFixed = Color(0xFFFFDF9E);
  static const Color onSecondaryFixed = Color(0xFF241A00);

  static const Color primaryFixed = Color(0xFFB9EAFF);
  static const Color onPrimaryFixed = Color(0xFF001F29);

  static const Color tertiaryFixed = Color(0xFF9EF0A8);
  static const Color onTertiaryFixed = Color(0xFF002108);
}

