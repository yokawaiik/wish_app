import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/language_item.dart';
import '../models/theme_item.dart';

import '../../translations/constants/translations_constants.dart'
    as translations_constants;

List<LanguageItem> languageDropdownList = [
  LanguageItem(
    value: 0,
    // title: "System",
    title: "settings_language_item_system".tr,
    locale: Get.deviceLocale ?? translations_constants.localeEnUS,
  ),
  LanguageItem(
    value: 1,
    // title: "English",
    title: "settings_language_item_english".tr,
    locale: translations_constants.localeEnUS,
  ),
  LanguageItem(
    value: 2,
    // title: "Russian",
    title: "settings_language_item_russian".tr,
    locale: translations_constants.localeRuRU,
  ),
];

List<ThemeItem> themeDropdownList = [
  ThemeItem(
    value: 0,
    mode: ThemeMode.system,
    // title: "System",
    title: "settings_theme_item_system".tr,
    icon: const Icon(Icons.brightness_auto),
  ),
  ThemeItem(
    value: 1,
    mode: ThemeMode.light,
    // title: "Light",
    title: "settings_theme_item_light".tr,
    icon: const Icon(Icons.brightness_4),
  ),
  ThemeItem(
    value: 2,
    mode: ThemeMode.dark,
    // title: "Dark",
    title: "settings_theme_item_dark".tr,
    icon: const Icon(Icons.brightness_4_outlined),
  ),
];
