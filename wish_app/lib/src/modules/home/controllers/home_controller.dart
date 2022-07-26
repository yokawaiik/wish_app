import 'package:get/get.dart';

class HomeController extends GetxController {
  final int nestedKey = 2;

  Future<bool> onWillPop() async {
    if (Get.nestedKey(nestedKey)!.currentState?.canPop() ?? true) {
      Get.nestedKey(nestedKey)!.currentState?.pop();
      return false;
    }
    return true;
  }
}
