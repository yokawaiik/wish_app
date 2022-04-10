import 'package:get/get.dart';
import 'package:wish_app/src/modules/splash/controllers/splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SplashController());
    Get.put(SplashController());
  }
}
