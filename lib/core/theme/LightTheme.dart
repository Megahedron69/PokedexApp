import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  brightness: Brightness.light,
  primaryColor: Color(0xFFFFCC00),
  scaffoldBackgroundColor: Color(0xFFFFDE00),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFFCC00),
    foregroundColor: Colors.black,
    elevation: 4,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFF8D030),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
);
