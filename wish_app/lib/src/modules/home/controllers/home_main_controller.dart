import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/favorites/api_services/favorites_api_service.dart';
import 'package:wish_app/src/modules/home/api_services/home_api_service.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/api_services/add_wish_api_service.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import '../../../services/user_service.dart';
import '../../navigator/controllers/navigator_controller.dart';

import '../../wish/views/wish_info_view.dart';
import '../constants/router_constants.dart' as router_constants;

class HomeMainController extends GetxController {
  final _supabase = Supabase.instance;
  final _userService = Get.find<UserService>();
  final _homeController = Get.find<HomeController>();

  late final ScrollController scrollController;

  RxBool get isUserAuthenticated => _userService.isUserAuthenticated;
  // bool get isUserAuthenticated2 => userService.isUserAuthenticated.value;

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    super.onInit();
    refreshWishList();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   refreshWishList();
  // }

  RxBool isLoading = RxBool(false);
  RxBool isDeleting = RxBool(false);

  int countWish = 0;
  int limit = 10;
  // int limit = 2;
  RxList<Wish> homeWishList = RxList();
  int get countLoadedWish => homeWishList.length;

  void _scrollListener() {
    if (countLoadedWish == countWish) return;

    // var position = scrollController.offset;
    var position = scrollController.positions.last.pixels;
    var maxScrollExtent = scrollController.positions.last.maxScrollExtent;
    var outOfRange = scrollController.positions.last.outOfRange;

    if (position >= maxScrollExtent &&
        // if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !outOfRange) {
      // print("comes to bottom $isLoading");
      // print("RUNNING LOAD MORE");
      loadWishList(countLoadedWish);
    }
  }

  Future<void> addNewWish() async {
    await Get.toNamed(AddWishView.routeName);
  }

  Future<void> refreshWishList() async {
    homeWishList.clear();
    countWish = 0;

    await loadCountOfWishInSubscriptions();
    await loadWishList(countLoadedWish, true);
  }

  Future<void> loadCountOfWishInSubscriptions() async {
    try {
      print("loadCountOfWishInSubscriptions");
      final loadedCountOfWish = await HomeService.countOfWishInSubscriptions(
        currentUserId: _userService.currentUser?.id,
      );

      print(loadedCountOfWish);

      if (loadedCountOfWish == null) return;

      countWish = loadedCountOfWish;
    } catch (e) {
      Get.snackbar(
          "Error loading a last wish list", "Something happened to server.");
    }
  }

  Future<void> loadWishList([int offset = 0, bool isRefresh = false]) async {
    try {
      print(offset);

      isLoading.value = true;
      List<Wish>? loadedWishList;

      if (isUserAuthenticated.isTrue) {
        loadedWishList = await HomeService.loadWishList(
          limit: limit,
          offset: countLoadedWish,
          currentUserId: _userService.currentUser!.id,
        );
      } else {
        // for guest
        loadedWishList = await HomeService.loadWishList(
          limit: limit,
          offset: countLoadedWish,
        );
      }

      if (loadedWishList == null) return;

      if (isRefresh) {
        homeWishList.clear();
      }

      homeWishList.addAll(loadedWishList);
      homeWishList.refresh();
    } catch (e) {
      Get.snackbar(
          "Error loading a last wish list", "Something happened to server.");
    } finally {
      isLoading.value = false;
    }
  }

  void addWish(Wish addedWish) {
    homeWishList.insert(0, addedWish);
    countWish += 1;
    homeWishList.refresh();
  }

  void updateWish(Wish updatedWish) {
    final oldTheWishIndex =
        homeWishList.indexWhere((element) => element.id == updatedWish.id);
    homeWishList[oldTheWishIndex] = updatedWish;
    homeWishList.refresh();
  }

  Future<void> onClickWishItem(int id) async {
    final homeController = Get.find<HomeController>();

    await Get.toNamed(
      WishInfoView.routeName,
      // arguments: {"id": id, "routeName": HomeView.routeName},
      arguments: WishInfoArguments(
        wishId: id,
        previousRouteName: router_constants.homeMainRouteName,
      ),
    );
  }

  //todo: shareWish
  void shareWish() {}

  void addToFavorites(int id) async {
    try {
      final foundWish = homeWishList.firstWhere((wish) => wish.id == id);

      await FavoritesApiService.toggleFavorite(
          id, _userService.currentUser!.id);

      foundWish.isFavorite = !foundWish.isFavorite;
      homeWishList.refresh();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("Unexpected error", "Something went wrong.");
    }
  }

  void deleteWish(int id) {
    homeWishList.removeWhere((wish) => wish.id == id);
    homeWishList.refresh();
  }

  void actionDeleteWish(Wish wish) async {
    try {
      Get.back(closeOverlays: true); // close modalBottomSheet
      isDeleting.value = true;
      await AddWishApiService.deleteWish(wish.id, wish.imagePath);
      deleteWish(wish.id);
    } catch (e) {
      print(e);
      Get.snackbar(
          "Error loading a last wish list", "Something happened to server.");
    } finally {
      isDeleting.value = false;
    }
  }

  void seeProfile(Wish wish) async {
    Get.back(closeOverlays: true);
    if (wish.createdBy.isCurrentUser) {
      Get.find<NavigatorController>().onItemTapped(2);
    } else {
      await Get.toNamed(
        router_constants.homeAccountRouteName,
        arguments: AccountArguments(
          wish.createdBy.id,
        ),
        preventDuplicates: false,
        id: _homeController.nestedKey,
      );
    }
  }

  Wish getWishById(int id) {
    return homeWishList.firstWhere((wish) => wish.id == id);
  }
}
