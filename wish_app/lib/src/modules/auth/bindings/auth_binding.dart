import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthBinding());
    Get.put(AuthController());
  }
}
