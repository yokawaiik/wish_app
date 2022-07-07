import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/favorites/api_services/favorites_api_service.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../../models/supabase_exception.dart';

import '../constants/favorites_constants.dart' as favorites_constants;

class FavoritesControllers extends GetxController {
  final _us = Get.find<UserService>();

  var favoritesWishList = RxList<Wish>([]);
  var countOfFavorites = RxInt(0);

  // ? info: for first load scroll
  var wasFirstLoad = Rx<bool>(true);
  var isLoading = Rx<bool>(false);

  // ? info: for infinite scroll
  late final ScrollController favoriteWishGridController;
  var isWishListLoad = false;
  var _offset = 0;
  // final _limit = favorites_constants.itemCountLimit;
  final _limit = 3;

  @override
  void onInit() async {
    favoriteWishGridController = ScrollController();
    favoriteWishGridController.addListener(favoritesWishListScrollListener);
    // ? info: socket listeners
    FavoritesApiService.addFavorite(addFavoriteHandler, _us.currentUser!.id);
    FavoritesApiService.deleteFavorite(deleteFavoriteHandler);

    await initLoading();
    super.onInit();
  }

  Future<void> initLoading() async {
    wasFirstLoad.value = true;
    await getCountOfFavorites();
    await loadFavoriteWishList();
    wasFirstLoad.value = false;
    countOfFavorites.refresh();
    favoritesWishList.refresh();
  }

  void favoritesWishListScrollListener() async {
    if (isWishListLoad == true) return;
    if (countOfFavorites.value == 0) return;

    if (_offset >= countOfFavorites.value) {
      return;
    }

    final itemRatio = _offset / countOfFavorites.value;
    final scrollPosition = favoriteWishGridController.position.pixels /
        favoriteWishGridController.position.maxScrollExtent;

    if (scrollPosition + favorites_constants.loadOffset >= itemRatio) {
      await loadFavoriteWishList();
      favoritesWishList.refresh();
      countOfFavorites.refresh(); // ? info: to update GridView
    }
  }

  //todo: add pagination logic
  void addFavoriteHandler(Wish addedWish) {
    favoritesWishList.add(addedWish);
    countOfFavorites.value += 1;
    _offset += 1;
    favoritesWishList.refresh();
  }

  //todo: add pagination logic
  void deleteFavoriteHandler(int deletedWishId) {
    favoritesWishList.removeWhere((wish) => wish.id == deletedWishId);
    countOfFavorites.value -= 1;
    _offset -= 1;
    favoritesWishList.refresh();
  }

  Future<void> loadFavoriteWishList() async {
    try {
      isWishListLoad = true;

      final gotThePartOfFavoriteWishList =
          await FavoritesApiService.loadFavoriteWishList(
        limit: _limit,
        offset: _offset,
        currentUserId: _us.currentUser!.id,
      );

      // print(
      //     "loadWishList - wishList.value?.length : ${gotThePartOfFavoriteWishList?.length}");

      // print(
      //     'loadFavoriteWishList - conditions : ${gotThePartOfFavoriteWishList == null || gotThePartOfFavoriteWishList.isEmpty}');

      if (gotThePartOfFavoriteWishList == null ||
          gotThePartOfFavoriteWishList.isEmpty) return;

      favoritesWishList.addAll(gotThePartOfFavoriteWishList);
      // favoritesWishList.refresh();

      _offset += gotThePartOfFavoriteWishList.length;
      // print('_offset : $_offset');

      // favoritesWishList.refresh();

      // print(
      //     'loadFavoriteWishList - favoritesWishList.length : ${favoritesWishList.length}');
    } on SupabaseException catch (e) {
      print(
          "FavoritesController - loadFavoriteWishList() - SupabaseException - e : $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("FavoritesController - loadFavoriteWishList() - e : $e");
      Get.snackbar("Error", "Unknown error...");
    } finally {
      isWishListLoad = false;
    }
  }

  Future<void> getCountOfFavorites() async {
    try {
      isWishListLoad = true;
      final gotThePartOfFavoriteWishList =
          await FavoritesApiService.getCountOfFavorites(_us.currentUser!.id);

      countOfFavorites.value = gotThePartOfFavoriteWishList ?? 0;
      // countOfFavorites.refresh();
    } on SupabaseException catch (e) {
      print(
          "FavoritesController - getCountOfFavorites() - SupabaseException - e : $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("FavoritesController - getCountOfFavorites() - e : $e");
      Get.snackbar("Error", "Unknown error...");
    } finally {
      isWishListLoad = false;
    }
  }

// todo: refreshFavoritesWishList
  Future<void> refreshFavorites() async {
    isLoading.value = true;
    _offset = 0;
    await getCountOfFavorites();
    favoritesWishList.clear();
    // favoritesWishList.refresh();

    await loadFavoriteWishList();

    isLoading.value = false;
    favoritesWishList.refresh();
    countOfFavorites.refresh();
  }

  // todo: toggleFavorite
  toggleFavorite(int id) {}

  // todo: onCardTap

  onCardTap(int id) {}
}
