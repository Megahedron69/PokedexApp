import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/core/utils/Extensions.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF393E46), // Slightly bluish-dark gray
  scaffoldBackgroundColor: const Color(0xFF121212), // Almost black
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF222831), // Dark bluish
    foregroundColor: Colors.white,
    elevation: 4,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF8D030), // Pikachu button still pops
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(color: Colors.white),
    displayMedium: const TextStyle(color: Colors.white),
    displaySmall: const TextStyle(color: Colors.white),

    headlineMedium: const TextStyle(color: Colors.white),
    headlineSmall: const TextStyle(color: Colors.white),

    bodyLarge: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: const TextStyle(
      fontSize: 16,
      color: Color(0xFFEEEEEE), // Off-white for better readability
    ),
    labelLarge: const TextStyle(color: Colors.yellowAccent),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white70),
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.yellowAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.yellowAccent),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFF8D030), // Consistent accent
    secondary: const Color(0xFFFFDE00), // Electric yellow
    surface: const Color(0xFF1C1C1C),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  ),
  extensions: [
    ToastColors(
      successBackground: Color(0xFF388E3C), // Darker green for success
      successForeground: Colors.white, // White text for success
      errorBackground: Color(0xFFD32F2F), // Darker red for error
      errorForeground: Colors.white, // White text for error
    ),
  ],
);
