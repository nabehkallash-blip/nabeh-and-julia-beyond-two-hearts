import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF100D20);
  static const surface = Color(0xFF211832);
  static const pink = Color(0xFFFF78B7);
  static const violet = Color(0xFF9B83FF);
  static const gold = Color(0xFFFFD58A);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: violet,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
