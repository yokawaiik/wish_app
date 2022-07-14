import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/settings_constants.dart' as settings_constants;
import '../constants/settings_option_lists_constants.dart'
    show themeDropdownList, languageDropdownList;
import '../models/language_item.dart';
import '../models/theme_item.dart';

ThemeMode setInitialTheme() {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  final selectedTheme =
      _settingsBox.read(settings_constants.selectedTheme) as int?;
  late ThemeItem selectedThemeItem;
  if (selectedTheme == null) {
    // ? info : default value
    selectedThemeItem = themeDropdownList.first;
  } else {
    selectedThemeItem =
        themeDropdownList.firstWhere((item) => item.value == selectedTheme);
  }

  return selectedThemeItem.mode;
}

Locale setInitialLocale() {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  final selectedLanguage =
      _settingsBox.read(settings_constants.selectedLanguage) as int?;
  late LanguageItem selectedanguageItem;
  if (selectedLanguage == null) {
    // ? info : default value
    selectedanguageItem = languageDropdownList.first;
  } else {
    selectedanguageItem = languageDropdownList
        .firstWhere((item) => item.value == selectedLanguage);
  }

  // return Locale(selectedanguageItem.code);
  return selectedanguageItem.locale;
}
