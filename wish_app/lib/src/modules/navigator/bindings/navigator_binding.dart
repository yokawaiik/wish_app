import 'package:get/get.dart';

import '../controllers/navigator_controller.dart';

class  NavigatorBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigatorController());
  }
}
