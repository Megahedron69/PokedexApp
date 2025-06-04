import 'package:flutter/material.dart';

String getFormattedDate(DateTime dt) {
  String day = dt.day.toString().padLeft(2, '0');
  String month = dt.month.toString().padLeft(2, '0');
  String year = dt.year.toString().substring(2);
  return "$day-$month-$year";
}

String getFormattedTime(TimeOfDay dt) {
  int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  String minute = dt.minute.toString().padLeft(2, '0');
  String period = dt.hour >= 12 ? "PM" : "AM";
  return "$hour:$minute $period";
}
