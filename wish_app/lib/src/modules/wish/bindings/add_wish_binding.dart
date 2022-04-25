import 'package:get/get.dart';
import 'package:wish_app/src/modules/wish/controllers/add_wish_controller.dart';

class AddWishBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddWishController());
  }
}
