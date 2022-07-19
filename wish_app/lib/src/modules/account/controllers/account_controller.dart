import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/api_services/account_api_service.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/account/views/account_edit_view.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';
import 'package:wish_app/src/modules/settings/views/setting_view.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import '../../global/models/user_account.dart';
import '../../global/services/user_service.dart';
import "../../global/utils/router_utils.dart" as router_utils;
import '../../global/constants/account_constants.dart' as account_constants;
import '../../global/api_services/add_wish_api_service.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/models/wish.dart';
import '../../global/utils/generate_wish_image_path.dart';
import '../../home/constants/router_constants.dart' as home_router_constants;
import '../views/account_view.dart';

class AccountController extends GetxController {
  final _userService = Get.find<UserService>();
  final _navigatorController = Get.find<NavigatorController>();
  final _homeController = Get.find<HomeController>();

  var userAccount = Rxn<UserAccount>();

  late RxnString imageUrl;

  var isLoading = Rx<bool>(false);
  var wishList = RxList<Wish>([]);

  var _offset = 0;
  final _limit = account_constants.itemCountLimit;
  late final ScrollController wishGridController;

  RxBool get isUserAuthenticated => _userService.isUserAuthenticated;
  RxBool get isCurrentUser => RxBool(userAccount.value?.isCurrentUser ?? false);

  bool isWishListLoad = false;

  late final AccountArguments? _args;

  @override
  void onInit() async {
    wishGridController = ScrollController();
    wishGridController.addListener(wishListScrollListener);

    imageUrl = RxnString(userAccount.value?.imageUrl);

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
    _args = Get.arguments as AccountArguments?;
  }

  Future<void> getUser() async {
    // print("AccountController - getUser()");
    try {
      // print('AccountController - initLoading - _args : ${_args}');

      // ? info: an unknown user visits someone's account
      if (_args != null && _args!.tag != null) {
        final gotTheUser = await AccountApiService.getUser(
          _args!.tag!,
          _userService.currentUser?.id,
        );

        userAccount.value = gotTheUser;
      } else if (_userService.isUserAuthenticated.value) {
        final gotTheUser = await AccountApiService.getUser(
          _userService.currentUser!.id,
          _userService.currentUser!.id,
        );

        userAccount.value = gotTheUser;
      } else {
        // throw SupabaseException("Error", "It isn't an user.");
        throw SupabaseException(
            "error_title".tr, "account_ac_es_it_is_not_an_user".tr);
      }
    } on SupabaseException catch (e) {
      // print("AccountController - getUser - SupabaseException - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar(e.title, e.msg);
      return;
    } catch (e) {
      // print("AccountController - getUser - e: $e");
      await router_utils.toBackOrMainPage();
      // Get.snackbar("Error", "Unknown error...");
      Get.snackbar("error_title".tr, "account_ac_e_unknown_error".tr);
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

      if (gotThePartOfWishList == null || gotThePartOfWishList.isEmpty) return;
      wishList.addAll(gotThePartOfWishList);
      _offset += gotThePartOfWishList.length;
      wishList.refresh();
    } on SupabaseException catch (e) {
      // print("AccountController - loadWishList() - SupabaseException - e : $e");
      Get.snackbar(e.title, e.msg);
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      // print("AccountController - loadWishList() - e : $e");
      // Get.snackbar("Error", "Unknown error...");
      Get.snackbar("error_title".tr, 'account_ac_e_unknown_error'.tr);
    } finally {
      isWishListLoad = false;
    }
  }

  Future<void> refreshAccountData() async {
    // print("refreshAccountData");
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

  // ? info: shows only for unauth user who sees profile belongs to another users
  void goToLoginPage() async {
    closeModalBottomSheet();
    await Get.toNamed(AuthView.routeName);
  }

  void deleteWish(int id) {
    wishList.removeWhere((element) => element.id == id);
    userAccount.value!.countOfWishes = userAccount.value!.countOfWishes! - 1;
    if (_offset > 0) {
      _offset -= 1;
    }

    wishList.refresh();
  }

  void goToWishInfo(int id) async {
    await Get.toNamed(
      WishInfoView.routeName,
      arguments: WishInfoArguments(
        wishId: id,
        previousRouteName: isCurrentUser.value
            ? AccountView.routeName
            : home_router_constants.homeAccountRouteName,
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
      // Get.snackbar("Error", "Error when subscribe.");
      Get.snackbar("error_title".tr, "account_ac_e_error_subscribing".tr);
      return;
    } catch (e) {
      // Get.snackbar("Error", "Unknown error...");
      Get.snackbar("error_title".tr, "account_ac_e_unknown_error".tr);
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

  void editProfile() async {
    await Get.toNamed(AccountEditView.routeName);
  }

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
      Get.snackbar("error_title".tr, "account_ac_e_error_subscribing".tr);
    } catch (e) {
      Get.snackbar("error_title".tr, "account_ac_e_unknown_error".tr);
    }
  }

  void updateUserAccountInfoByFields({String? login, String? imageUrl}) {
    if (login != null) {
      userAccount.value!.login = login;
    }

    if (imageUrl != null) {
      userAccount.value!.imageUrl = imageUrl;
    }
    userAccount.refresh();
  }

  void goToSettings() {
    Get.toNamed(SettingView.routeName);
  }
}
