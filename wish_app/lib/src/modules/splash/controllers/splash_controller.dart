import 'dart:async';

import 'package:get/get.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';

import '../../global/services/user_service.dart';

class SplashController extends GetxController {
  final userService = Get.find<UserService>();

  @override
  void onReady() {
    super.onReady();
    loading();
  }

  Future<void> loading() async {
    Timer(const Duration(seconds: 2), () {
      Get.offAndToNamed(NavigatorView.routeName);
    });
  }
}
