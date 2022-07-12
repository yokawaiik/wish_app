import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';

import '../controllers/account_edit_controller.dart';

class AccountEditBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountEditController());
  }
}
