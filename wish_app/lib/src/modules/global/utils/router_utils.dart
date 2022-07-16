import 'package:get/get.dart';

import '../../navigator/views/navigator_view.dart';
import '../../wish/views/wish_info_view.dart';

Future<void> toBackOrMainPage() async {
  if ([
    WishInfoView.routeName,
    NavigatorView.routeName,
  ].contains(Get.previousRoute)) {
    Get.back();
  } else {
    await Get.offNamedUntil(NavigatorView.routeName, (route) => false);
  }
}
