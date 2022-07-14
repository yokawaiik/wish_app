import 'package:flutter/material.dart';

class ThemeItem {
  ThemeMode mode;
  int value;
  String title;
  Icon icon;

  ThemeItem({
    required this.value,
    required this.mode,
    required this.title,
    required this.icon,
  });
}
