import 'package:flutter/material.dart';

const Color seedColorTheme = Colors.teal;
const Color seedColorDarkTheme = Colors.purple;

const favoriteColor = Colors.purple;
const unFavoriteColor = Colors.grey;

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