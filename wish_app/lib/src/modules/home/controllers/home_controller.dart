import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/home/services/home_service.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import '../../../services/user_service.dart';

class HomeController extends GetxController {
  final _supabase = Supabase.instance;
  final userService = Get.find<UserService>();

  late final ScrollController scrollController;

  Rx<bool> get isUserAuthenticated => userService.isUserAuthenticated;

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    refreshWishList();
  }

  RxBool isLoading = RxBool(false);
  int countWish = 0;
  int limit = 10;
  // int limit = 2;
  RxList<Wish> homeWishList = RxList();
  int get countLoadedWish => homeWishList.length;

  void _scrollListener() {
    if (countLoadedWish == countWish) return;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
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

    await loadCountOfWishInSubscriptions();
    await loadWishList(countLoadedWish, true);
  }

  Future<void> loadCountOfWishInSubscriptions() async {
    try {
      print("loadCountOfWishInSubscriptions");
      final loadedCountOfWish = await HomeService.countOfWishInSubscriptions(
        currentUserId: userService.currentUser?.id,
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
          currentUserId: userService.currentUser!.id,
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
    await Get.toNamed(
      WishInfoView.routeName,
      arguments: {"id": id, "routeName": HomeView.routeName},
    );
  }
}
