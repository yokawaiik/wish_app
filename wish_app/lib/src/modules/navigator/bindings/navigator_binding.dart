import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/favorites/controllers/favorites_controllers.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';

import '../../global/services/user_service.dart';
import '../controllers/navigator_controller.dart';

class NavigatorBindings extends Bindings {
  @override
  void dependencies() {
    final userService = Get.find<UserService>();

    if (GetPlatform.isMobile) {
      Get.put(NavigatorController(), permanent: true);
      Get.put(HomeController(), permanent: true);

      if (userService.isUserAuthenticated.isTrue) {
        Get.put(
          AccountController(),
          tag: userService.currentUser!.id,
          permanent: true,
        );
        Get.put(
          FavoritesController(),
          permanent: true,
        );
      }
    }
    // Todo: Else - variant for desktop
  }
}
