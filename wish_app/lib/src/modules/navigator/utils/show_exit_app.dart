import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<bool> showExitPopup() async {
  bool? result = await Get.defaultDialog(
    title: "Leave app",
    middleText: "Do you want to leave?",
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
