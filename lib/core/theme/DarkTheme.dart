import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  brightness: Brightness.dark,
  primaryColor: Color(0xFF222831),
  scaffoldBackgroundColor: Color(0xFF1C1C1C), // Dark Gray
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF393E46),
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
      backgroundColor: Color(0xFFF8D030), // Pikachu Yellow Button
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
  ),
);
