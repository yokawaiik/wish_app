import 'package:get/get.dart';
import 'package:wish_app/src/modules/settings/models/language_item.dart';
import 'package:wish_app/src/modules/settings/models/theme_item.dart';

import '../constants/settings_option_lists_constants.dart'
    as settings_option_lists_constants;

import '../utils/settings_utils.dart' as settings_utils;

class SettingsController extends GetxController {
  late RxInt selectedValueLanguageDropdown;
  List<LanguageItem> languageDropdownList =
      settings_option_lists_constants.languageDropdownList;

  late RxInt selectedValueThemeDropdown;
  List<ThemeItem> themeDropdownList =
      settings_option_lists_constants.themeDropdownList;

  @override
  void onInit() {
    _setInitialSettings();

    super.onInit();
  }

  // ? info: set all settings
  void _setInitialSettings() {
    selectedValueLanguageDropdown =
        RxInt(settings_utils.getCurrentLocale().value);

    selectedValueThemeDropdown = RxInt(settings_utils.getCurrentTheme().value);
  }

  void onChangedLanguageDropdown(int? value) {
    if (value == null) return;
    final selectedLanguage = languageDropdownList[value];
    _setLanguage(selectedLanguage);
    selectedValueLanguageDropdown.value = value;
  }

  void _setLanguage(LanguageItem languageItem) {
    settings_utils.saveLocale(languageItem);
    Get.updateLocale(languageItem.locale);
  }

  void onChangedThemeDropdown(int? value) {
    if (value == null) return;
    final selectedTheme = themeDropdownList[value];
    _setTheme(selectedTheme);
    selectedValueThemeDropdown.value = value;
  }

  void _setTheme(ThemeItem selectedTheme) {
    settings_utils.saveTheme(selectedTheme);

    Get.changeThemeMode(selectedTheme.mode);
  }
}
