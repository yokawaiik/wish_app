import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/controllers/auth_controller.dart';
import 'package:wish_app/src/services/user_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthBinding());
    // Get.put(UserService());
  }
}
