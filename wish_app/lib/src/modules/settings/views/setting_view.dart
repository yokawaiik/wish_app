import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/settings/controllers/settings_controller.dart';

import '../../global/constants/global_constants.dart' as global_constants;

class SettingView extends GetView<SettingsController> {
  static const routeName = '/settings';

  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("settings_appbar_title".tr),
        ),
        body: ListView(
          padding: const EdgeInsets.all(global_constants.defaultPadding),
          shrinkWrap: true,
          children: [
            DropdownButton<int>(
              value: controller.selectedValueLanguageDropdown.value,
              underline: const SizedBox(),
              isExpanded: true,
              items: controller.languageDropdownList
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.value,
                      child: ListTile(
                        title: Text(
                          item.title.tr,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.onChangedLanguageDropdown,
            ),
            const SizedBox(
              height: global_constants.defaultPadding,
            ),
            DropdownButton<int>(
              value: controller.selectedValueThemeDropdown.value,
              underline: const SizedBox(),
              isExpanded: true,
              items: controller.themeDropdownList
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.value,
                      child: ListTile(
                        leading: item.icon,
                        title: Text(item.title.tr),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.onChangedThemeDropdown,
            ),
          ],
        ),
      ),
    );
  }
}
