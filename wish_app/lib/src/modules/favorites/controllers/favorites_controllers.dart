import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/favorites/api_services/favorites_api_service.dart';
import 'package:wish_app/src/modules/favorites/views/favorites_view.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/home/controllers/home_main_controller.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import '../../account/models/account_arguments.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/models/wish.dart';
import '../../global/services/user_service.dart';
import '../constants/favorites_constants.dart' as favorites_constants;
import '../../home/constants/router_constants.dart' as home_router_constants;

class FavoritesController extends GetxController {
  final _us = Get.find<UserService>();
  final _nc = Get.find<NavigatorController>();
  final _hc = Get.find<HomeController>();

  var favoritesWishList = RxList<Wish>([]);
  var countOfFavorites = RxInt(0);

  // ? info: for first load scroll
  var wasFirstLoad = Rx<bool>(true);
  var isLoading = Rx<bool>(false);

  // ? info: for infinite scroll
  late final ScrollController favoriteWishGridController;

  var isWishListLoad = false;
  var _offset = 0;
  final _limit = favorites_constants.itemCountLimit;

  @override
  void onInit() async {
    favoriteWishGridController = ScrollController();
    favoriteWishGridController.addListener(favoritesWishListScrollListener);

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

  void addFavoriteHandler(Wish addedWish) {
    favoritesWishList.insert(0, addedWish);
    countOfFavorites.value += 1;
    _offset += 1;
    favoritesWishList.refresh();
    countOfFavorites.refresh();
  }

  void deleteFavoriteHandler(int deletedWishId) {
    final _hmc = Get.find<HomeMainController>();
    bool _findWish(Wish wish) => wish.id == deletedWishId;

    // ? info: if favoritesWishList doesn't have exists row in cloud database
    if (favoritesWishList.indexWhere(_findWish) != -1) {
      favoritesWishList.removeWhere(_findWish);
      _offset -= 1;
      favoritesWishList.refresh();
    }

    _hmc.toggleFavoriteIfExists(deletedWishId);

    countOfFavorites.value -= 1;
    countOfFavorites.refresh();
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

      if (gotThePartOfFavoriteWishList == null ||
          gotThePartOfFavoriteWishList.isEmpty) return;
      favoritesWishList.addAll(gotThePartOfFavoriteWishList);
      _offset += gotThePartOfFavoriteWishList.length;
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
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
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
    } finally {
      isWishListLoad = false;
    }
  }

  Future<void> refreshFavorites() async {
    isLoading.value = true;
    _offset = 0;
    await getCountOfFavorites();
    favoritesWishList.clear();
    await loadFavoriteWishList();
    isLoading.value = false;
    favoritesWishList.refresh();
    countOfFavorites.refresh();
  }

  Future<void> toggleFavorite(int id) async {
    try {
      // todo, toggleFavorite: maybe add load animation while element deleting
      await FavoritesApiService.toggleFavorite(id, _us.currentUser!.id);

      deleteFavoriteHandler(id);
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
    }
  }

  void onCardTap(int id) async {
    await Get.toNamed(
      WishInfoView.routeName,
      arguments: WishInfoArguments(
        wishId: id,
        previousRouteName: FavoritesView.routeName,
      ),
    );
  }

  void seeProfile(Wish wish) async {
    Get.back(closeOverlays: true);
    _nc.onItemTapped(1);

    await Get.toNamed(
      home_router_constants.homeAccountRouteName,
      id: _hc.nestedKey,
      arguments: AccountArguments(
        wish.createdBy.id,
      ),
      preventDuplicates: false,
    );
  }

  void removeFromFavorite(int id) async {
    Get.back(closeOverlays: true);
    await toggleFavorite(id);
  }
}
