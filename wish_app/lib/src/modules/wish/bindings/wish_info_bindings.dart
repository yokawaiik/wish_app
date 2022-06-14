import 'package:get/get.dart';
import '../controllers/wish_info_controller.dart';

class WishInfoBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(WishInfoController());
  }
}
