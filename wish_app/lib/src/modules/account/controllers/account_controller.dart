import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/user_account.dart';
import 'package:wish_app/src/modules/account/api_services/account_api_service.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../../models/wish.dart';
import "../../../utils/router_utils.dart" as router_utils;

// import '../../../constants/account_constants.dart' show itemCountLimit, loadOffset;
import '../../../constants/account_constants.dart' as account_constants;

class AccountController extends GetxController {
  final _userService = Get.find<UserService>();

  var userAccount = Rxn<UserAccount>();
  var isLoading = Rx<bool>(false);
  // var wishList = Rxn<List<Wish>>();
  var wishList = RxList<Wish>([]);

  var _offset = 0;
  // todo: change it
  final _limit = account_constants.itemCountLimit;
  // final _limit = 5;
  late final ScrollController wishGridController;

  Rx<bool> get isUserAuthenticated => _userService.isUserAuthenticated;

  bool isWishListLoad = false;

  @override
  void onInit() async {
    wishGridController = ScrollController();
    wishGridController.addListener(() async {
      // ? info: it needs to not to load wish list again while previous load wasnt ready
      if (isWishListLoad == true) return;
      if (userAccount.value!.countOfWishes == null) return;
      if (_offset >= userAccount.value!.countOfWishes!) return;

      final itemRatio = _offset / userAccount.value!.countOfWishes!;

      final scrollPosition = wishGridController.offset /
          wishGridController.position.maxScrollExtent;

      // print('scrollPosition : $scrollPosition');
      // print('itemRatio - ${itemRatio}');
      print(
          'scrollPosition >= itemRatio - ${scrollPosition + 0.2 >= itemRatio}');

      if (scrollPosition + account_constants.loadOffset >= itemRatio) {
        await loadWishList();
      }
    });

    initLoading();
    super.onInit();
  }

  void initLoading() async {
    isLoading.value = true;
    await getUser();
    await loadWishList();
    isLoading.value = false;
  }

  Future<void> getUser() async {
    print("AccountController - getUser()");
    try {
      // an unknown user visits someone's account
      if (Get.arguments != null && Get.arguments["id"] != null) {
        final gotTheUser = await AccountApiService.getUser(
          Get.arguments["id"],
          null,
        );
        if (gotTheUser == null) {
          throw SupabaseException("Error", "Such an user didn't find.");
        }

        userAccount.value = gotTheUser;
        // my account
      } else if (_userService.isUserAuthenticated.value) {
        final gotTheUser = (await _userService.getCurrentUserDetail);
        if (gotTheUser == null) {
          throw SupabaseException(
              "Error", "Something went wrong when get user details...");
        }

        userAccount.value = gotTheUser;
        userAccount.refresh();
      } else {
        throw SupabaseException("Error", "It isn't an user.");
      }
    } on SupabaseException catch (e) {
      print("AccountController - getUser - SupabaseException - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AccountController - getUser - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar("Error", "Unknown error...");
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
    isLoading.value = true;
    await getUser();
    _offset = 0;
    wishList.clear();
    await loadWishList();
    isLoading.value = false;
  }

  // todo: createWish
  void createWish() async {
    await Get.toNamed(AddWishView.routeName);
  }

  // todo: exit
  void exit() {}

  // todo: goToLoginPage
  void goToLoginPage() {}
}
