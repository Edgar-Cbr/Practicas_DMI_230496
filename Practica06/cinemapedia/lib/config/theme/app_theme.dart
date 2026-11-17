import 'package:flutter/material.dart';

class AppTheme {

  // Paleta moderna de cine oscuro:
  // Fondo obsidiana cinematográfico, acento púrpura eléctrico neón,
  // toques cian para contraste y oro ámbar para calificaciones.
  static const Color darkBackground = Color(0xFF090A10);
  static const Color surfaceColor = Color(0xFF131522);
  static const Color cardColor = Color(0xFF1A1D2E);
  static const Color primaryNeon = Color(0xFFA855F7); // Púrpura eléctrico
  static const Color secondaryNeon = Color(0xFF06B6D4); // Cian vibrante
  static const Color ratingGold = Color(0xFFFBBF24); // Oro de estrellas

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryNeon,
      brightness: Brightness.dark,
      surface: surfaceColor,
    ).copyWith(
      primary: primaryNeon,
      secondary: secondaryNeon,
      tertiary: ratingGold,
      surface: surfaceColor,
      surfaceContainer: cardColor,
      outline: Colors.white.withValues(alpha: 0.12),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      canvasColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: primaryNeon,
        unselectedItemColor: Colors.white54,
      ),
    );
  }

}
