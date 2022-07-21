import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/home/api_services/wishes_and_users_search_api_service.dart';
import 'package:wish_app/src/modules/home/database/suggestions_storage_helper.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';

import '../../global/models/light_user.dart';
import '../../global/models/light_wish.dart';
import '../../global/services/user_service.dart';

class WishesAndUsersSearchController extends GetxController {
  final _us = Get.find<UserService>();

  late final SuggestionsStorageHelper _ssh;

  WishesAndUsersSearchController() {
    _ssh = SuggestionsStorageHelper.instance;
  }

  bool get isListsEmpty => searchUserList.isEmpty && searchWishList.isEmpty;

  List<LightUser> searchUserList = [];

  List<LightUser> suggestionsSearchUserList =
      []; // ? info: items that have been opened

  Future<void> getSearchUserList() async {
    try {
      final gotSearchUserList =
          await WishesAndUsersSearchApiService.getSearchUserList(
        query,
        _us.currentUser?.id,
      );

      searchUserList = gotSearchUserList ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<AccountArguments> tapOnSearchUser(String id) async {
    if (searchUserList.length >= 10) {
      searchUserList.removeLast();
    }

    if (!suggestionsSearchUserList.any((user) => user.id == id)) {
      final selectedUser = searchUserList.firstWhere((user) => user.id == id);
      suggestionsSearchUserList.insert(0, selectedUser);

      await _saveUserInSuggestionsStorage(selectedUser);
    }

    return AccountArguments(id);
  }

  Future<void> _saveUserInSuggestionsStorage(LightUser selectedUser) async {
    await _ssh.addUser(selectedUser);
  }

  Future<void> removeFromSuggestionsSearchUserList(String id) async {
    suggestionsSearchUserList.removeWhere((user) => user.id == id);

    await _ssh.removeUser(id);
  }

  List<LightWish> searchWishList = [];

  List<LightWish> suggestionsSearchWishList =
      []; // ? info: items that have been opened

  Future<void> getSearchWishList() async {
    try {
      final gotSearchWishList =
          await WishesAndUsersSearchApiService.getSearchWishList(query);

      searchWishList = gotSearchWishList ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<WishInfoArguments> tapOnSearchWish(int id) async {
    if (suggestionsSearchWishList.length >= 10) {
      suggestionsSearchWishList.removeLast();
    }

    if (!suggestionsSearchWishList.any((wish) => wish.id == id)) {
      final selectedWish = searchWishList.firstWhere((wish) => wish.id == id);
      suggestionsSearchWishList.insert(0, selectedWish);

      await _saveWishInSuggestionsStorage(selectedWish);
    }

    return WishInfoArguments(
      wishId: id,
      previousRouteName: HomeView.routeName,
    );
  }

  String query = "";
  Future<void> search() async {
    try {
      _clearResults();

      await Future.wait([
        getSearchUserList(),
        getSearchWishList(),
      ]);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_m_something_went_wrong".tr);
    }
  }

  Future<void> setSuggestions() async {
    try {
      _clearSuggestions();

      final gotSuggestions =
          await Future.wait([_ssh.getWishList(), _ssh.getUserList()]);

      suggestionsSearchWishList.addAll(gotSuggestions[0] as List<LightWish>);
      suggestionsSearchUserList.addAll(gotSuggestions[1] as List<LightUser>);
    } catch (e) {
      if (kDebugMode) {
        print('setSuggestions() - e : $e');
      }
    }
  }

  void _clearSuggestions() {
    suggestionsSearchWishList.clear();
    suggestionsSearchUserList.clear();
  }

  void _clearResults() {
    searchUserList.clear();
    searchWishList.clear();
  }

  Future<void> removeFromSuggestionsSearchWishList(int id) async {
    suggestionsSearchWishList.removeWhere((wish) => wish.id == id);

    await _ssh.removeWish(id);
  }

  Future<void> _saveWishInSuggestionsStorage(LightWish selectedWish) async {
    await _ssh.addWish(selectedWish);
  }
}
