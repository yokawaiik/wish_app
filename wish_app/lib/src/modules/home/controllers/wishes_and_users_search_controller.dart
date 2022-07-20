import 'dart:async';

import 'package:get/get.dart';
import 'package:wish_app/src/modules/home/api_services/wishes_and_users_search_api_service.dart';
import 'package:wish_app/src/modules/home/database/suggestions_storage_helper.dart';

import '../../global/models/light_user.dart';
import '../../global/models/light_wish.dart';
import '../../global/services/user_service.dart';

class WishesAndUsersSearchController extends GetxController {
  final _us = Get.find<UserService>();

  late final SuggestionsStorageHelper _ssh;

  String selectedResult = "";

  WishesAndUsersSearchController() {
    _ssh = SuggestionsStorageHelper.instance;
  }

  bool get isLastListsEmpty =>
      suggestionsSearchUserList.isEmpty && suggestionsSearchWishList.isEmpty;

  List<LightUser> searchUserList = [];
  // List<LightUser> suggestionsSearchUserList =
  //     []; // ? info: items that have been opened
  RxList<LightUser> suggestionsSearchUserList =
      RxList<LightUser>([]); // ? info: items that have been opened

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

  void tapOnSearchUser(String id) async {
    // // TODO:tapOnSearchUser
    // print(id);

    // // TODO: add selectedWish to list and save it in storage but not more then 10
    if (searchUserList.length >= 10) {
      searchUserList.removeLast();
    }

    if (suggestionsSearchUserList.any((user) => user.id == id)) return;

    final selectedUser = searchUserList.firstWhere((user) => user.id == id);
    suggestionsSearchUserList.insert(0, selectedUser);

    await _saveUserInSuggestionsStorage(selectedUser);
  }

  Future<void> _saveUserInSuggestionsStorage(LightUser selectedUser) async {
    // // TODO: _saveUserInSuggestionsStorage
    // throw UnimplementedError();

    await _ssh.addUser(selectedUser);
  }

  Future<void> removeFromSuggestionsSearchUserList(String id) async {
    await _ssh.removeUser(id);
    suggestionsSearchUserList.removeWhere((user) => user.id == id);
    suggestionsSearchUserList.refresh();
  }

  List<LightWish> searchWishList = [];
  // List<LightWish> suggestionsSearchWishList =
  //     []; // ? info: items that have been opened

  RxList<LightWish> suggestionsSearchWishList =
      RxList<LightWish>([]); // ? info: items that have been opened

  Future<void> getSearchWishList() async {
    try {
      final gotSearchWishList =
          await WishesAndUsersSearchApiService.getSearchWishList(query);

      searchWishList = gotSearchWishList ?? [];
    } catch (e) {
      rethrow;
    }
  }

  void tapOnSearchWish(int id) async {
    //print(id);
    // // TODO:tapOnSearchWish

    // // TODO: add selectedWish to list and save it in storage but not more then 10
    if (suggestionsSearchWishList.length >= 10) {
      suggestionsSearchWishList.removeLast();
    }

    if (suggestionsSearchWishList.any((wish) => wish.id == id)) return;

    final selectedWish = searchWishList.firstWhere((wish) => wish.id == id);
    suggestionsSearchWishList.insert(0, selectedWish);

    await _saveWishInSuggestionsStorage(selectedWish);
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
      Get.snackbar("Error", "Something went wrong.");
    }
    // // todo: remove it
    // await Future.delayed(Duration(seconds: 2));
  }

  RxBool isSuggestionsLoad = RxBool(false);

  // RxList<LightWish> get suggestionsWishList =>
  //     RxList<LightWish>(suggestionsSearchWishList);
  // RxList<LightUser> get suggestionsUserList =>
  //     RxList<LightUser>(suggestionsSearchUserList);

  Future<void> setSuggestions() async {
    try {
      print("setSuggestions()");
      isSuggestionsLoad.value = true;
      // final gotSuggestionWishList = await _ssh.getWishList();
      // final gotSuggestionUserList = await _ssh.getUserList();
      _clearSuggestions();

      final gotSuggestions =
          await Future.wait([_ssh.getWishList(), _ssh.getUserList()]);

      suggestionsSearchWishList.addAll(gotSuggestions[0] as List<LightWish>);
      suggestionsSearchUserList.addAll(gotSuggestions[1] as List<LightUser>);
    } catch (e) {
      print('setSuggestions() - e : $e');
    } finally {
      isSuggestionsLoad.value = false;
      suggestionsSearchWishList.refresh();
      suggestionsSearchUserList.refresh();
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
    await _ssh.removeWish(id);
    suggestionsSearchWishList.removeWhere((wish) => wish.id == id);
    suggestionsSearchWishList.refresh();
  }

  Future<void> _saveWishInSuggestionsStorage(LightWish selectedWish) async {
    // // TODO: _saveWishInSuggestionsStorage
    // throw UnimplementedError();

    await _ssh.addWish(selectedWish);
  }
}
