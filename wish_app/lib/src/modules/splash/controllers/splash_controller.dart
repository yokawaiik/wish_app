import 'dart:async';

import 'package:get/get.dart';
import 'package:wish_app/src/modules/global/bindings/global_binding.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    await loading();
  }

  Future<void> loading() async {
    await GlobalBinding().dependencies();
  }
}
