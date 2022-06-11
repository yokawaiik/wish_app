import 'package:get/get.dart';
import '../controllers/wish_info_controller.dart';

class WishInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WishInfoController());
  }
}
