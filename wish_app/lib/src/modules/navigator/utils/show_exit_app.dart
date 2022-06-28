import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<bool> showExitPopup() async {
  bool result = await Get.defaultDialog(
    title: "Do you want to leave?",
    onConfirm: () {
      Get.back(result: true);
      if (GetPlatform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
    },
    onCancel: () {
      Get.back(result: false);
    },
  );

  return result;
}
