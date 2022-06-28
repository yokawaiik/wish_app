import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/home_main_controller.dart';

class HomeMainBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeMainController(), permanent: true);
  }
}
