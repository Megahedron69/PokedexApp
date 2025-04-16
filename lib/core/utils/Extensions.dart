import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringLowerCasingExtension on String {
  String lowercize() {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }
}

extension SizeExtension on BuildContext {
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;
}

class ToastColors extends ThemeExtension<ToastColors> {
  final Color successBackground;
  final Color successForeground;
  final Color errorBackground;
  final Color errorForeground;

  ToastColors({
    required this.successBackground,
    required this.successForeground,
    required this.errorBackground,
    required this.errorForeground,
  });

  @override
  ToastColors copyWith({
    Color? successBackground,
    Color? successForeground,
    Color? errorBackground,
    Color? errorForeground,
  }) {
    return ToastColors(
      successBackground: successBackground ?? this.successBackground,
      successForeground: successForeground ?? this.successForeground,
      errorBackground: errorBackground ?? this.errorBackground,
      errorForeground: errorForeground ?? this.errorForeground,
    );
  }

  @override
  ToastColors lerp(ThemeExtension<ToastColors>? other, double t) {
    if (other is! ToastColors) return this;
    return ToastColors(
      successBackground:
          Color.lerp(successBackground, other.successBackground, t)!,
      successForeground:
          Color.lerp(successForeground, other.successForeground, t)!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
      errorForeground: Color.lerp(errorForeground, other.errorForeground, t)!,
    );
  }
}
