import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AccountBindings extends Bindings {
  String? tag;
  bool isAnotherUser;

  AccountBindings({
    this.tag,
    this.isAnotherUser = false,
  });

  @override
  void dependencies() {
    if (isAnotherUser) {
      Get.put(
        AccountController(),
        tag: tag,
      );
    } else {
      Get.put(
        AccountController(),
        permanent: true,
        tag: tag,
      );
    }
  }
}
