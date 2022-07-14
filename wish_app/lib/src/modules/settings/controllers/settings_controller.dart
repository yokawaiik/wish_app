import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wish_app/src/modules/settings/models/language_item.dart';
import 'package:wish_app/src/modules/settings/models/theme_item.dart';

import '../constants/settings_constants.dart' as settings_constants;
import '../constants/settings_option_lists_constants.dart'
    as settings_option_lists_constants;

class SettingsController extends GetxController {
  final _settingsBox = GetStorage(settings_constants.settingsBox);

  late RxInt selectedValueLanguageDropdown;
  List<LanguageItem> languageDropdownList =
      settings_option_lists_constants.languageDropdownList;

  late RxInt selectedValueThemeDropdown;
  List<ThemeItem> themeDropdownList =
      settings_option_lists_constants.themeDropdownList;

  // @override
  // void onInit() {
  //   // _setInitialSettings();
  //   super.onInit();
  // }

  // ? info: set all settings
  // void setInitialSettings() {
  //   final selectedTheme =
  //       _settingsBox.read(settings_constants.selectedTheme) as int?;
  //   late ThemeItem selectedThemeItem;
  //   if (selectedTheme == null) {
  //     // ? info : default value
  //     selectedThemeItem = themeDropdownList.first;
  //   } else {
  //     selectedThemeItem =
  //         themeDropdownList.firstWhere((item) => item.value == selectedTheme);
  //   }

  //   _setTheme(selectedThemeItem);
  //   selectedValueThemeDropdown.value = selectedThemeItem.value;

  //   final selectedLanguage =
  //       _settingsBox.read(settings_constants.selectedLanguage) as int?;
  //   late LanguageItem selectedanguageItem;
  //   if (selectedLanguage == null) {
  //     // ? info : default value
  //     selectedanguageItem = languageDropdownList.first;
  //   } else {
  //     selectedanguageItem = languageDropdownList
  //         .firstWhere((item) => item.value == selectedLanguage);
  //   }

  //   _setLanguage(selectedanguageItem);
  //   selectedValueLanguageDropdown.value = selectedanguageItem.value;
  // }

  void onChangedLanguageDropdown(int? value) {
    if (value == null) return;
    final selectedLanguage = languageDropdownList[value];
    _setLanguage(selectedLanguage);
  }

  void _setLanguage(LanguageItem languageItem) {
    // // todo: _setLanguage
    _settingsBox.write(settings_constants.selectedLanguage, languageItem.value);

    final locale = languageItem.locale;
    Get.updateLocale(locale);
  }

  void onChangedThemeDropdown(int? value) {
    if (value == null) return;
    final selectedTheme = themeDropdownList[value];
    _setTheme(selectedTheme);
  }

  void _setTheme(ThemeItem selectedTheme) {
    // // todo: save to storage
    _settingsBox.write(settings_constants.selectedTheme, selectedTheme.value);
    Get.changeThemeMode(selectedTheme.mode);
  }
}
