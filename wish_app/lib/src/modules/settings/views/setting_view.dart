import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:wish_app/src/modules/settings/controllers/settings_controller.dart';

import '../../global/constants/global_constants.dart' as global_constants;

import '../../translations/constants/translations_constants.dart' show settings;

class SettingView extends GetView<SettingsController> {
  static const routeName = '/settings';

  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Settings"),
        title: Text("settings_appbar_title".tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(global_constants.defaultPadding),
        shrinkWrap: true,
        children: [
          // ListTile(
          //   leading: Icon(Icons.language),
          // ),
          // TODO: DropdownButton with language change
          DropdownButton<int>(
            value: controller.selectedValueLanguageDropdown.value,
            isExpanded: true,
            items: controller.languageDropdownList
                .map(
                  (item) => DropdownMenuItem(
                    value: item.value,
                    child: ListTile(
                      title: Text(
                        item.title,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: controller.onChangedLanguageDropdown,
          ),
          DropdownButton<int>(
            value: controller.selectedValueThemeDropdown.value,
            isExpanded: true,
            items: controller.themeDropdownList
                .map(
                  (item) => DropdownMenuItem(
                    value: item.value,
                    child: ListTile(
                      leading: item.icon,
                      title: Text(item.title),
                    ),
                  ),
                )
                .toList(),
            onChanged: controller.onChangedThemeDropdown,
          ),
          // TODO: theme change
          // const ListTile(
          //   leading: const Icon(
          //     // Icons.brightness_4,
          //     Icons.brightness_4_outlined,
          //   ),
          // ),
        ],
      ),
    );
  }
}
