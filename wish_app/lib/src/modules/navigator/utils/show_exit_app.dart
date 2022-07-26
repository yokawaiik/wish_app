import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<bool> showExitPopup() async {
  bool? result = await Get.defaultDialog(
    // title: "Leave app",
    // middleText: "Do you want to leave?",
    // textConfirm: "",
    // textCancel: "",
    title: "nm_u_show_exit_popup_title".tr,
    middleText: "nm_u_show_exit_popup_content".tr,
    textConfirm: "nm_u_show_exit_popup_confirm".tr,
    textCancel: "nm_u_show_exit_popup_cancel".tr,
    onConfirm: () async {
      if (GetPlatform.isIOS) {
        exit(0);
      } else {
        await SystemNavigator.pop();
      }
      Get.back(result: true);
    },
    onCancel: () {
      Get.back(result: false, closeOverlays: true);
    },
  );

  return result ?? false;
}
