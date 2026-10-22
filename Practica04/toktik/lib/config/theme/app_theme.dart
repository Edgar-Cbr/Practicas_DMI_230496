import 'package:flutter/material.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';

class AppTheme {
  AppTheme(this.season);

  final SeasonalTheme season;

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: season.fontFamily,
    // Si la fuente temática no tiene un carácter (acentos, signos), se usa Poppins.
    fontFamilyFallback: const ['Poppins'],
    colorScheme: ColorScheme.fromSeed(
      seedColor: season.primaryColor,
      secondary: season.secondaryColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF101014),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: season.primaryColor.withValues(alpha: 0.94),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: season.primaryColor,
      foregroundColor: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: season.secondaryColor.withValues(alpha: 0.35),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF14141A),
      modalBackgroundColor: Color(0xFF14141A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF22222B),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
