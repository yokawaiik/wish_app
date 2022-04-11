import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/favorites/views/favorites_view.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../auth/views/auth_view.dart';
import '../services/navigator_service.dart';

class NavigatorController extends GetxController {
  final _supabase = Supabase.instance;

  final userService = Get.find<UserService>();

  Rx<bool> get isUserAuthenticated => userService.isUserAuthenticated;

  var selectedIndex = RxInt(1);

  List<Widget> views = [
    FavoritesView(),
    HomeView(),
    AccountView(),
  ];

  get currentView => views[selectedIndex.value];

  Future<void> signOut() async {
    printInfo(info: 'NavigatorController - signOut()');
    await NavigatorService.signOut();
    await Get.offAllNamed(AuthView.routeName);
  }

  Future<void> goToAuthView() async {
    Get.back();
    await Get.toNamed(AuthView.routeName);
  }

  void onItemTapped(int value) {
    switch (value) {
      case 2:
        if (!userService.isAuthenticated)
          Get.toNamed(AuthView.routeName);
        else
          selectedIndex.value = value;
        break;
      default:
        selectedIndex.value = value;
    }
  }
}
