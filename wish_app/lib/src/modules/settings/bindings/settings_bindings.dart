import 'package:get/instance_manager.dart';
import 'package:wish_app/src/modules/settings/controllers/settings_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
