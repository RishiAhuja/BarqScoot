import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:escooter/core/configs/theme/app_colors.dart';

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        color: textColor,
      ),
      // Add other text styles as needed
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.primaryTeal,
      textTheme: _buildTextTheme(base.textTheme, Colors.black),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      primaryColor: AppColors.primaryTeal,
      textTheme: _buildTextTheme(base.textTheme, Colors.white),
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryTeal,
        onPrimary: Colors.grey[900] ?? Colors.black,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        surface: Colors.grey[900] ?? Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900] ?? Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[900] ?? Colors.black,
        elevation: 2,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
