import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/favorites/controllers/favorites_controllers.dart';
import 'package:wish_app/src/modules/favorites/views/favorites_view.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import '../../account/models/account_arguments.dart';
import '../../auth/views/auth_view.dart';
import '../../global/services/user_service.dart';
import '../../global/widgets/keep_alive_wrapper.dart';
import '../../home/controllers/home_controller.dart';
import '../utils/show_exit_app.dart';

class NavigatorController extends GetxController {
  final userService = Get.find<UserService>();

  RxBool get isUserAuthenticated => userService.isUserAuthenticated;
  // late AccountArguments accountArguments;

  var selectedIndex = RxInt(1);
  late final PageController pageViewController;

  late List<Widget> views;
  Widget get currentView => views[selectedIndex.value];

  @override
  void onInit() {
    views = [
      _createFavoriteView(),
      const KeepAliveWrapper(child: HomeView()),
      _createAccountView(),
    ];

    pageViewController = PageController(initialPage: selectedIndex.value);

    super.onInit();
  }

  Widget _createAccountView() {
    if (isUserAuthenticated.value) {
      final tag = userService.currentUser!.id;
      return KeepAliveWrapper(
        child: AccountView(
          tag: tag,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _createFavoriteView() {
    if (isUserAuthenticated.value) {
      return const KeepAliveWrapper(child: FavoritesView());
    } else {
      return const SizedBox();
    }
  }

  Future<void> signOut() async {
    try {
      await userService.signOut();

      if ([0, 2].contains(selectedIndex.value)) {
        onItemTapped(selectedIndex.value);
      }

      updateNavigator();
    } catch (e) {
      Get.snackbar("error_title".tr, "error_m_something_went_wrong".tr);
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

  void updateNavigator() {
    final tag = userService.currentUser!.id;
    if (userService.isUserAuthenticated.value) {
      Get.put(
        AccountController(),
        tag: tag,
        permanent: true,
      );

      Get.put(
        FavoritesController(),
        permanent: true,
      );

      views.last = KeepAliveWrapper(child: _createAccountView());

      views.first = KeepAliveWrapper(child: _createFavoriteView());
    } else {
      Get.delete<AccountController>(tag: tag);
      Get.delete<FavoritesController>();
      views.last = const SizedBox();
      views.first = const SizedBox();
    }
    selectedIndex.refresh();
  }
}
