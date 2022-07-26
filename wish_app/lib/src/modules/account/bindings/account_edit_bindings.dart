import 'package:get/get.dart';

import '../controllers/account_edit_controller.dart';

class AccountEditBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountEditController());
  }
}
