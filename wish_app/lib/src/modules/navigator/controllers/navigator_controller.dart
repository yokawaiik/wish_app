import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/favorites/controllers/favorites_controllers.dart';
import 'package:wish_app/src/modules/favorites/views/favorites_view.dart';
import 'package:wish_app/src/modules/home/controllers/home_main_controller.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../../widgets/keep_alive_wrapper.dart';
import '../../account/models/account_arguments.dart';
import '../../auth/views/auth_view.dart';
import '../../home/controllers/home_controller.dart';
import '../api_services/navigator_api_service.dart';
import '../utils/show_exit_app.dart';

class NavigatorController extends GetxController {
  final _supabase = Supabase.instance;
  final userService = Get.find<UserService>();

  RxBool get isUserAuthenticated => userService.isUserAuthenticated;
  late AccountArguments accountArguments;

  var selectedIndex = RxInt(1);
  late final PageController pageViewController;

  late List<Widget> views;
  Widget get currentView => views[selectedIndex.value];

  @override
  void onInit() {
    // views = [
    //   FavoritesView(),
    //   HomeView(),
    //   _createAccountView(),
    // ];
    views = [
      KeepAliveWrapper(child: FavoritesView()),
      KeepAliveWrapper(child: HomeView()),
      KeepAliveWrapper(child: _createAccountView()),
    ];

    pageViewController = PageController(initialPage: selectedIndex.value);

    super.onInit();
  }

  AccountView _createAccountView() {
    if (isUserAuthenticated.value) {
      accountArguments = AccountArguments(userService.currentUser!.id);
    } else {
      accountArguments = AccountArguments();
    }

    return AccountView(
      tag: accountArguments.tag,
    );
  }

  Future<void> signOut() async {
    try {
      final tag = userService.currentUser!.id;

      final acIsRegistered = Get.isRegistered<AccountController>(tag: tag);

      if (!isUserAuthenticated.value && acIsRegistered) {
        await Get.delete<AccountController>(tag: tag);
      }

      await userService.signOut();

      if ([0, 2].contains(selectedIndex.value)) {
        onItemTapped(selectedIndex.value);
      }

      updateAccountView();
    } catch (e) {
      print('NavigatorController - e : $e');
      Get.snackbar("Error", "Something went wrong.");
    }
  }

  Future<void> goToAuthView() async {
    Get.back();
    await Get.toNamed(AuthView.routeName);
  }

  void onItemTapped(int value) {
    switch (value) {
      case 0:
      case 2:
        if (!userService.isUserAuthenticated.value) {
          Get.toNamed(AuthView.routeName);
          selectedIndex.value = 1;
        } else {
          Get.put(
            AccountController(),
            tag: accountArguments.tag,
            permanent: true,
          );

          Get.put(
            FavoritesController(),
            permanent: true,
          );

          selectedIndex.value = value;
        }
        break;
      default:
        selectedIndex.value = value;
    }

    pageViewController.jumpToPage(selectedIndex.value);
  }

  Future<bool> appOnWillPop() async {
    final homeController = Get.find<HomeController>();

    if (!(await homeController.onWillPop())) return false;

    return (await showExitPopup());
  }

  void updateAccountView() {
    views.last = KeepAliveWrapper(child: _createAccountView());
  }
}
