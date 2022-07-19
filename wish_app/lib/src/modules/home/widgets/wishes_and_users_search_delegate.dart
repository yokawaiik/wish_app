import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/global/models/light_user.dart';
import 'package:wish_app/src/modules/global/models/light_wish.dart';
import 'package:wish_app/src/modules/global/widgets/account_user_avatar.dart';
import 'package:wish_app/src/modules/home/controllers/wishes_and_users_search_controller.dart';

import '../../global/extensions/wish_color.dart';

class WishesAndUsersSearchDelegate extends SearchDelegate {
  late final WishesAndUsersSearchController _waus;

  // String selectedResult = "";
  final List<dynamic> recentList = [];
  final List<dynamic>? listMatching = [];

  WishesAndUsersSearchDelegate() {
    _waus = Get.put(WishesAndUsersSearchController());

    // _waus = Get.find<WishesAndUsersSearchController>();
  }

  @override
  void close(BuildContext context, result) {
    Get.delete<WishesAndUsersSearchController>();
    super.close(context, result);
  }

  @override
  void showResults(BuildContext context) {
    _waus.query = query;

    super.showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchUserList = _waus.searchUserList;
    final searchWishList = _waus.searchWishList;

    return FutureBuilder(
        future: _waus.search(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _userListViewBuilder(searchUserList),
                if (searchWishList.isNotEmpty) ...[
                  Divider(),
                ],
                // Divider(),
                _wishListViewBuilder(searchWishList),
              ],
            ),
          );
        });
  }

  ListView _wishListViewBuilder(List<LightWish> searchWishList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: searchWishList.length,
      itemBuilder: (context, index) {
        final wish = searchWishList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          // TODO: extract to widget
          // TODO: onTap with adding to last List
          // TODO: dismissible - https://pub.dev/packages/flutter_slidable
          child: ListTile(
            leading: AccountUserAvatar(
              defaultColor: Colors.purple,
              userHexColor: wish.userColor,
              imageUrl: null,
              radius: 30,
            ),
            title: Text("Test"),
          ),
        );
      },
    );
  }

  ListView _userListViewBuilder(List<LightUser> searchUserList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchUserList.length,
      itemBuilder: (context, index) {
        final user = searchUserList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          // TODO: extract to widget
          // TODO: onTap with adding to last List
          // TODO: dismissible - https://pub.dev/packages/flutter_slidable
          child: ListTile(
            leading: AccountUserAvatar(
              defaultColor: Colors.purple,
              userHexColor: user.userColor,
              imageUrl: null,
              radius: 30,
            ),
            title: Text("Test"),
          ),
        );
      },
    );
  }

  List<dynamic> suggestionList = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    final testList = List<int>.generate(
      10,
      (index) => index,
    );

    return ListView.builder(
      itemCount: testList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text('suggest - u${testList[i].toString()}'),
        );
      },
    );
  }
}
