import 'package:flutter/material.dart';

class ThemeItem {
  final ThemeMode mode;
  final int value;
  final String title;
  final Icon icon;

  ThemeItem({
    required this.value,
    required this.mode,
    required this.title,
    required this.icon,
  });
}
