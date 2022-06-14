import 'package:get/get.dart';
import 'package:wish_app/src/modules/wish/controllers/add_wish_controller.dart';

class AddWishBindings extends Bindings {
  @override
  void dependencies() {
    // Get.put(AddWishController());

    Get.lazyPut<AddWishController>(() => AddWishController());
  }
}
