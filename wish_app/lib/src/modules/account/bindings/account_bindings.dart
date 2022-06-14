import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AccountBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}
