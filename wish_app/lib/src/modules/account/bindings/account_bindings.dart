import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AccountBindings extends Bindings {
  String? tag;

  AccountBindings([this.tag]);

  @override
  void dependencies() {
    Get.put(
      AccountController(),
      permanent: true,
      tag: tag,
    );
  }
}
