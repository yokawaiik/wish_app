import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/settings_constants.dart' as settings_constants;
import '../constants/settings_option_lists_constants.dart'
    show themeDropdownList, languageDropdownList;
import '../models/language_item.dart';
import '../models/theme_item.dart';

// ? info: initialize GetStorage instance for settings
Future<void> initStorage() async {
  await GetStorage.init(settings_constants.settingsBox);
}

// ? info: set initial theme when app start first time
ThemeMode setInitialTheme() {
  late ThemeItem selectedThemeItem = getCurrentTheme();

  return selectedThemeItem.mode;
}

// ? info: save selected theme to storage
void saveTheme(ThemeItem themeItem) async {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  await _settingsBox.write(settings_constants.selectedTheme, themeItem.value);
}

// ? info: get current theme from storage
ThemeItem getCurrentTheme() {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  final selectedTheme =
      _settingsBox.read(settings_constants.selectedTheme) as int?;

  late ThemeItem selectedThemeItem;
  if (selectedTheme == null) {
    // ? info : default value
    selectedThemeItem = themeDropdownList.first;
    saveTheme(selectedThemeItem);
  } else {
    selectedThemeItem =
        themeDropdownList.firstWhere((item) => item.value == selectedTheme);
  }

  return selectedThemeItem;
}

// ? info: set initial locale
Locale setInitialLocale() {
  late LanguageItem selectedanguageItem = getCurrentLocale();
  return selectedanguageItem.locale;
}

// ? info: get current locale
LanguageItem getCurrentLocale() {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  final selectedLanguage =
      _settingsBox.read(settings_constants.selectedLanguage) as int?;
  late LanguageItem selectedanguageItem;
  if (selectedLanguage == null) {
    // ? info : default value
    selectedanguageItem = languageDropdownList.first;
    saveLocale(selectedanguageItem);
  } else {
    selectedanguageItem = languageDropdownList
        .firstWhere((item) => item.value == selectedLanguage);
  }

  return selectedanguageItem;
}

// ? info: save selected theme to storage
void saveLocale(LanguageItem languageItem) async {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  await _settingsBox.write(
      settings_constants.selectedLanguage, languageItem.value);
}
