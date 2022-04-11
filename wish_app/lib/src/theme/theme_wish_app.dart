import 'package:flutter/material.dart';




final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
    // primary: Colors.lime,
    // secondary: Colors.grey,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
    // primary: Colors.yellow,
    // secondary: Colors.grey,
  ),
);
