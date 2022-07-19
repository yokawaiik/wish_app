import 'dart:async';

import 'package:get/get.dart';
import 'package:wish_app/src/modules/home/api_services/wishes_and_users_search_api_service.dart';

import '../../global/models/light_user.dart';
import '../../global/models/light_wish.dart';
import '../../global/services/user_service.dart';

class WishesAndUsersSearchController extends GetxController {
  final _us = Get.find<UserService>();

  String selectedResult = "";
  // final List<dynamic> recentList = [];

  // final List<SearchUser>? searchUserList = [
  //   SearchUser(
  //     id: "1",
  //     login: "Wish 1",
  //     imageUrl: null,
  //     userColor: Colors.green.toHex(),
  //   ),
  //   SearchUser(
  //     id: "2",
  //     login: "Wish 2",
  //     imageUrl: null,
  //     userColor: Colors.green.toHex(),
  //   ),
  // ];

  List<LightUser> searchUserList = [];

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

  void tapOnSearchUser(int id) {
    // TODO:tapOnSearchWish
  }

  // final List<SearchWish>? searchWishList = [
  //   SearchWish(
  //     id: 1,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User",
  //     imageUrl: null,
  //   ),
  //   SearchWish(
  //     id: 2,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User 2",
  //     imageUrl: null,
  //   ),
  //   SearchWish(
  //     id: 1,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User",
  //     imageUrl: null,
  //   ),
  //   SearchWish(
  //     id: 2,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User 2",
  //     imageUrl: null,
  //   ),
  //   SearchWish(
  //     id: 1,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User",
  //     imageUrl: null,
  //   ),
  //   SearchWish(
  //     id: 2,
  //     userColor: Colors.yellow.toHex(),
  //     title: "User 2",
  //     imageUrl: null,
  //   ),
  // ];
  List<LightWish> searchWishList = [];

  Future<void> getSearchWishList() async {
    try {
      final gotSearchWishList =
          await WishesAndUsersSearchApiService.getSearchWishList(query);

      searchWishList = gotSearchWishList ?? [];
    } catch (e) {
      rethrow;
    }
  }

  void tapOnSearchWish(int id) {
    // TODO:tapOnSearchWish
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

  void _clearResults() {
    query = "";
    searchUserList.clear();
    searchWishList.clear();
  }
}
