import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/api_services/user_api_service.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/user_account.dart';
import 'package:wish_app/src/modules/account/api_services/account_api_service.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/home/controllers/home_main_controller.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';
import 'package:wish_app/src/api_services/add_wish_api_service.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/utils/generate_wish_image_path.dart';

import '../../../models/wish.dart';
import "../../../utils/router_utils.dart" as router_utils;

// import '../../../constants/account_constants.dart' show itemCountLimit, loadOffset;
import '../../../constants/account_constants.dart' as account_constants;
import '../views/account_view.dart';

class AccountController extends GetxController {
  final _userService = Get.find<UserService>();
  final _navigatorController = Get.find<NavigatorController>();
  final _homeController = Get.find<HomeController>();

  var userAccount = Rxn<UserAccount>();
  var isLoading = Rx<bool>(false);
  var wishList = RxList<Wish>([]);

  var _offset = 0;
  final _limit = account_constants.itemCountLimit;
  late final ScrollController wishGridController;

  RxBool get isUserAuthenticated => _userService.isUserAuthenticated;
  RxBool get isCurrentUser => RxBool(userAccount.value?.isCurrentUser ?? false);

  bool isWishListLoad = false;

  late final AccountArguments? args;

  @override
  void onInit() async {
    wishGridController = ScrollController();
    wishGridController.addListener(wishListScrollListener);

    await initLoading();
    super.onInit();
  }

  void wishListScrollListener() async {
    if (isWishListLoad == true) return;
    if (userAccount.value?.countOfWishes == null) return;
    if (userAccount.value!.countOfWishes != null &&
        _offset >= userAccount.value!.countOfWishes!) return;

    final itemRatio = _offset / userAccount.value!.countOfWishes!;
    final scrollPosition =
        wishGridController.offset / wishGridController.position.maxScrollExtent;

    print('itemRatio : ${itemRatio}');
    print('scrollPosition : $scrollPosition');
    // final itemRatio = _offset / userAccount.value!.countOfWishes!;
    // final scrollPosition = wishGridController.position.pixels /
    //     wishGridController.position.maxScrollExtent;

    // final itemRatio = _offset / userAccount.value!.countOfWishes!;
    // final scrollPosition = wishGridController.positions.last.pixels /
    //     wishGridController.positions.last.maxScrollExtent;

    if (scrollPosition + account_constants.loadOffset >= itemRatio) {
      await loadWishList();
    }
  }

  Future<void> initLoading() async {
    _setArguments();
    isLoading.value = true;
    await getUser();
    await loadWishList();
    isLoading.value = false;
  }

  void _setArguments() {
    args = Get.arguments as AccountArguments?;
  }

  Future<void> getUser() async {
    print("AccountController - getUser()");
    try {
      print('AccountController - initLoading - args : ${args}');

      // an unknown user visits someone's account
      if (args != null && args!.tag != null) {
        final gotTheUser = await AccountApiService.getUser(
          args!.tag!,
          _userService.currentUser?.id,
        );

        userAccount.value = gotTheUser;
      } else if (_userService.isUserAuthenticated.value) {
        // final gotTheUser = (await _userService.getCurrentUserDetail);
        final gotTheUser = await AccountApiService.getUser(
          _userService.currentUser!.id,
          _userService.currentUser!.id,
        );

        userAccount.value = gotTheUser;
        // userAccount.refresh();
      } else {
        throw SupabaseException("Error", "It isn't an user.");
      }
    } on SupabaseException catch (e) {
      print("AccountController - getUser - SupabaseException - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar(e.title, e.msg);
      return;
    } catch (e) {
      print("AccountController - getUser - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar("Error", "Unknown error...");
      return;
    } finally {
      userAccount.refresh();
    }
  }

  Future<void> loadWishList() async {
    try {
      isWishListLoad = true;
      final gotThePartOfWishList = await AccountApiService.getTheUserWishes(
        userAccount.value!.id,
        limit: _limit,
        offset: _offset,
        currentUserId: _userService.currentUser?.id,
      );

      // print("loadWishList - wishList.value?.length : ${gotThePartOfWishList}");

      if (gotThePartOfWishList == null || gotThePartOfWishList.isEmpty) return;
      wishList.addAll(gotThePartOfWishList);
      _offset += gotThePartOfWishList.length;
      wishList.refresh();
    } on SupabaseException catch (e) {
      print("AccountController - loadWishList() - SupabaseException - e : $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AccountController - loadWishList() - e : $e");
      Get.snackbar("Error", "Unknown error...");
    } finally {
      isWishListLoad = false;
    }
  }

  Future<void> refreshAccountData() async {
    print("refreshAccountData");
    isLoading.value = true;
    await getUser();
    _offset = 0;
    wishList.clear();
    await loadWishList();
    isLoading.value = false;
  }

  void createWish() async {
    closeModalBottomSheet();
    await Get.toNamed(AddWishView.routeName);
  }

  void signOut() async {
    closeModalBottomSheet(); // hide bottomModalSheet

    if (isCurrentUser.isFalse) {
      Get.back(id: _homeController.nestedKey);
    }

    await _navigatorController.signOut();
  }

  // ? shows only for unauth user who sees profile belongs to another users
  void goToLoginPage() async {
    closeModalBottomSheet();
    await Get.toNamed(AuthView.routeName);
  }

  void deleteWish(int id) {
    wishList.removeWhere((element) => element.id == id);
    userAccount.value!.countOfWishes = userAccount.value!.countOfWishes! - 1;
    _offset = -1;
    wishList.refresh();
  }

  void goToWishInfo(int id) async {
    await Get.toNamed(
      WishInfoView.routeName,
      arguments: WishInfoArguments(
        wishId: id,
        previousRouteName: AccountView.routeName,
      ),
    );
  }

  var isSubscribing = Rx<bool>(false);
  void toggleSubscription() async {
    try {
      isSubscribing.value = true;
      await AccountApiService.subscribe(
        _userService.currentUser!.id,
        userAccount.value!.id,
      );

      userAccount.value!.hasSubscribe = !userAccount.value!.hasSubscribe;

      if (userAccount.value!.hasSubscribe) {
        userAccount.value!.countOfsubscribers =
            userAccount.value!.countOfsubscribers! + 1;
      } else {
        userAccount.value!.countOfsubscribers =
            userAccount.value!.countOfsubscribers! - 1;
      }
    } on SupabaseException catch (e) {
      Get.snackbar("Error", "Error when subscribe.");
      return;
    } catch (e) {
      Get.snackbar("Error", "Unknown error...");
      return;
    } finally {
      isSubscribing.value = false;
      userAccount.refresh();
    }
  }

  void addWish(Wish wish) {
    wishList.insert(0, wish);
    _offset += 1;
    userAccount.value!.countOfWishes = userAccount.value!.countOfWishes! + 1;
    wishList.refresh();
  }

  void updateTheWish(Wish updatedWish) {
    final oldTheWishIndex =
        wishList.indexWhere((element) => element.id == updatedWish.id);
    wishList[oldTheWishIndex] = updatedWish;
    wishList.refresh();
  }

  // todo: editProfile
  void editProfile() {}

  void goToMyAccountPage() {
    Get.back(id: _homeController.nestedKey);
    _navigatorController.onItemTapped(2);
  }

  closeModalBottomSheet() {
    if (isCurrentUser.isFalse) {
      Get.back(closeOverlays: true, id: _homeController.nestedKey);
    } else {
      Get.back();
    }
  }

  Future<void> removeWish(int id) async {
    try {
      final theFoundWish = wishList.firstWhere((item) => item.id == id);

      String? imagePath;
      if (theFoundWish.hasImage) {
        imagePath =
            generateWishImagePath(theFoundWish.imageUrl!, id.toString());
      }

      await AddWishApiService.deleteWish(id, imagePath);

      deleteWish(id);
    } on SupabaseException catch (e) {
      Get.snackbar("Error", "Error when subscribe.");
    } catch (e) {
      Get.snackbar("Error", "Unknown error...");
    }
  }
}
