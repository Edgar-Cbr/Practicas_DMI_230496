import 'package:flutter/material.dart';

class AppTheme {

  // Paleta de Alta Gama Cinematográfica:
  // Fondo obsidiana terciopelo, acento en Oro Ámbar cinematográfico (Golden Age / Oscars),
  // reflejos en Cian Láser y contraste con titanio ahumado.
  static const Color darkBackground = Color(0xFF08090E);
  static const Color surfaceColor = Color(0xFF111420);
  static const Color cardColor = Color(0xFF161926);
  static const Color primaryGold = Color(0xFFF59E0B); // Oro ámbar estelar
  static const Color secondaryCyan = Color(0xFF06B6D4); // Cian vibrante
  static const Color rubyAccent = Color(0xFFEF4444); // Rubí para favoritos
  static const Color ratingGold = Color(0xFFFBBF24); // Estrellas doradas

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGold,
      brightness: Brightness.dark,
      surface: surfaceColor,
    ).copyWith(
      primary: primaryGold,
      secondary: secondaryCyan,
      tertiary: rubyAccent,
      surface: surfaceColor,
      surfaceContainer: cardColor,
      outline: Colors.white.withValues(alpha: 0.1),
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
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: primaryGold.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: primaryGold,
        unselectedItemColor: Colors.white54,
      ),
    );
  }

}
