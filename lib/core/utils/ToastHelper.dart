import 'package:flutter/material.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required ToastificationType toastType,
  required String title,
  required String description,
}) {
  final theme = Theme.of(context); // Access the theme

  // Determine the colors based on the toast type
  Color backgroundColor =
      toastType == ToastificationType.success
          ? theme.extension<ToastColors>()!.successBackground
          : theme.extension<ToastColors>()!.errorBackground;

  Color foregroundColor =
      toastType == ToastificationType.success
          ? theme.extension<ToastColors>()!.successForeground
          : theme.extension<ToastColors>()!.errorForeground;

  // Show the toast with the desired properties
  toastification.show(
    context: context,
    type: toastType,
    style: ToastificationStyle.fillColored,
    title: Text(title),
    description: Text(description),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 4),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    primaryColor: foregroundColor,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    icon: Icon(
      toastType == ToastificationType.success
          ? Icons.check_circle
          : Icons.error,
    ),
    boxShadow: highModeShadow,
    dragToClose: true,
  );
}
