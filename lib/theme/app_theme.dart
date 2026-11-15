import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF101D2B);
  static const surface = Color(0xFF182A3A);
  static const teal = Color(0xFF38D6C3);
  static const blue = Color(0xFF69A9FF);
  static const amber = Color(0xFFFFC46B);
  static const red = Color(0xFFFF7676);

  static ThemeData build({bool highContrast = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: highContrast ? Colors.cyanAccent : teal,
      brightness: Brightness.dark,
      surface: highContrast ? Colors.black : surface,
      primary: highContrast ? Colors.cyanAccent : teal,
      secondary: blue,
      error: const Color(0xFFFF7676),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: highContrast ? Colors.black : navy,
      cardTheme: CardThemeData(
        color: highContrast ? const Color(0xFF050505) : surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: highContrast ? const Color(0xFF111111) : const Color(0xFF203447),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: highContrast ? Colors.white70 : Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: navy,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
