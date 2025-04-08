import 'package:flutter/material.dart';

const Map<String, Color> typeColors = {
  "bug": Color(0xFF26DE81),
  "dragon": Color(0xFFFFEAA7),
  "electric": Color(0xFFFED330),
  "fairy": Color(0xFFFF0069),
  "fighting": Color(0xFF30336B),
  "fire": Color(0xFFF0932B),
  "flying": Color(0xFF81ECEC),
  "grass": Color(0xFF00B894),
  "ground": Color(0xFFEFB549),
  "ghost": Color(0xFFA55EEA),
  "ice": Color(0xFF74B9FF),
  "normal": Color(0xFF95AFC0),
  "poison": Color(0xFF6C5CE7),
  "psychic": Color(0xFFA29BFE),
  "rock": Color(0xFF2D3436),
  "water": Color(0xFF0190FF),
};

Color getColorForType(String type) {
  return typeColors[type.toLowerCase()] ?? Colors.grey;
}
