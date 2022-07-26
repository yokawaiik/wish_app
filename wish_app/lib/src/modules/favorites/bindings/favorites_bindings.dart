import 'package:get/get.dart';
import 'package:wish_app/src/modules/favorites/controllers/favorites_controllers.dart';

class FavoritesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
  }
}
