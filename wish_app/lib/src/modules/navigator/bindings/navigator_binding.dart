import 'package:get/get.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';

import '../controllers/navigator_controller.dart';

class NavigatorBindings extends Bindings {
  @override
  void dependencies() {
    if (GetPlatform.isMobile) {
      Get.put(NavigatorController(), permanent: true);
      Get.put(HomeController());
    }
    // Todo: Else - variant for desktop
  }
}
