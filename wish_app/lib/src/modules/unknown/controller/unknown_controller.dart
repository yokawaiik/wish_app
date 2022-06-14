import 'package:get/get.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';

import '../../wish/views/wish_info_view.dart';

class UnknownController extends GetxController {
  Future<void> backHandler() async {
    if ([WishInfoView.routeName].contains(Get.previousRoute)) {
      Get.back();
    } else {
      Get.toNamed(NavigatorView.routeName);
    }
  }
}
