import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/global/models/light_user.dart';
import 'package:wish_app/src/modules/global/models/light_wish.dart';
import 'package:wish_app/src/modules/global/widgets/account_user_avatar.dart';
import 'package:wish_app/src/modules/home/controllers/wishes_and_users_search_controller.dart';
import 'package:wish_app/src/modules/home/widgets/search_list_tile.dart';

import '../../global/extensions/wish_color.dart';

import '../../global/constants/global_constants.dart' as global_constants;

class WishesAndUsersSearchDelegate extends SearchDelegate {
  late final WishesAndUsersSearchController _waus;

  WishesAndUsersSearchDelegate() {
    _waus = Get.put(WishesAndUsersSearchController());
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

  // ? info: build when query is empty
  Widget _buildEmptyResults(BuildContext context) {
    return const Center(
      child: Text("Your query is empty..."),
    );
  }

  // ? info: build when user opened search
  Widget _buildEmptySuggestions(BuildContext context) {
    return const Center(
      child: Text("You dont have any suggestions..."),
    );
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
    if (query.isEmpty) {
      return _buildEmptyResults(context);
    }

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

          final searchUserList = _waus.searchUserList;
          final searchWishList = _waus.searchWishList;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: global_constants.defaultHeight,
                ),
                if (searchUserList.isNotEmpty) ...[
                  const Center(
                    child: Text("Users"),
                  ),
                  _userListViewBuilder(searchUserList, slidableEnabled: false),
                ],
                if (searchWishList.isNotEmpty) ...[
                  const Divider(),
                  const Center(
                    child: Text("Wishes"),
                  ),
                  const SizedBox(
                    height: global_constants.defaultHeight,
                  ),
                  _wishListViewBuilder(searchWishList, slidableEnabled: false),
                ],
              ],
            ),
          );
        });
  }

  ListView _wishListViewBuilder(
    List<LightWish> searchWishList, {
    bool slidableEnabled = true,
  }) {
    final colorScheme = Get.theme.colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchWishList.length,
      itemBuilder: (context, index) {
        final wish = searchWishList[index];

        // TODO: extract to widget
        // // TODO: onTap with adding to last List
        // // TODO: dismissible - https://pub.dev/packages/flutter_slidable

        return SearchListTile(
          enabled: slidableEnabled,
          key: ValueKey(wish.id),
          onTap: () => _tapOnSearchWish(wish.id),
          slideActionOnPressedDelete: (_) =>
              _removeFromLastSearchWishList(wish.id),
          leading: AccountUserAvatar(
            defaultColor: colorScheme.background,
            userColor: wish.userColor == null
                ? colorScheme.onBackground
                : WishColor.fromHex(wish.userColor!).withOpacity(0.1),
            imageUrl: wish.imageUrl,
            radius: 30,
            iconChild: Icon(
              Icons.person,
              size: 50,
              color: wish.userColor == null
                  ? Get.theme.colorScheme.onPrimary
                  : WishColor.fromHex(wish.userColor!).invert(),
            ),
          ),
          title: Text(wish.title),
        );
      },
    );
  }

  ListView _userListViewBuilder(
    List<LightUser> searchUserList, {
    bool slidableEnabled = true,
  }) {
    final colorScheme = Get.theme.colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchUserList.length,
      itemBuilder: (context, index) {
        final user = searchUserList[index];

        return SearchListTile(
          enabled: slidableEnabled,
          key: ValueKey(user.id),
          onTap: () => _tapOnSearchUser(user.id),
          slideActionOnPressedDelete: (_) =>
              _removeFromLastSearchUserList(user.id),
          leading: AccountUserAvatar(
            defaultColor: colorScheme.background,
            userColor: user.userColor == null
                ? colorScheme.onBackground
                : WishColor.fromHex(user.userColor!).withOpacity(0.1),
            imageUrl: user.imageUrl,
            radius: 30,
            iconChild: Icon(
              Icons.person,
              size: 50,
              color: user.userColor == null
                  ? Get.theme.colorScheme.onPrimary
                  : WishColor.fromHex(user.userColor!).invert(),
            ),
          ),
          title: Text(user.login),
        );
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   return FutureBuilder(
  //       future: _waus.setSuggestions(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         if (snapshot.hasError) {
  //           return const Center(
  //             child: Text("Something went wrong..."),
  //           );
  //         }

  //         final lastSearchUserList = _waus.suggestionsSearchUserList;
  //         final lastSearchWishList = _waus.suggestionsSearchWishList;

  //         print("buildSuggestions - lastSearchUserList : $lastSearchUserList");
  //         print("buildSuggestions - lastSearchWishList : $lastSearchWishList");
  //         if (_waus.isLastListsEmpty) {
  //           _buildEmptyResults(context);
  //         }

  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: global_constants.defaultHeight,
  //               ),
  //               if (lastSearchWishList.isNotEmpty) ...[
  //                 const Center(
  //                   child: Text("Users"),
  //                 ),
  //                 _userListViewBuilder(lastSearchUserList),
  //               ],
  //               if (lastSearchWishList.isNotEmpty) ...[
  //                 const Divider(),
  //                 const Center(
  //                   child: Text("Wishes"),
  //                 ),
  //                 const SizedBox(
  //                   height: global_constants.defaultHeight,
  //                 ),
  //                 _wishListViewBuilder(lastSearchWishList),
  //               ],
  //             ],
  //           ),
  //         );
  //       });
  // }
  @override
  Widget buildSuggestions(BuildContext context) {
    // return GetBuilder<WishesAndUsersSearchController>(
    //     // future: _waus.setSuggestions(
    //     builder: (controller) {
    //   if (controller.isSuggestionsLoad.value) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }
    //   // if (controller) {
    //   //   return const Center(
    //   //     child: Text("Something went wrong..."),
    //   //   );
    //   // }

    //   // final lastSearchUserList = controller.suggestionsSearchUserList;
    //   // final lastSearchWishList = controller.suggestionsSearchWishList;
    //   final lastSearchUserList = controller.suggestionsUserList;
    //   final lastSearchWishList = controller.suggestionsWishList;

    //   print("buildSuggestions - lastSearchUserList : $lastSearchUserList");
    //   print("buildSuggestions - lastSearchWishList : $lastSearchWishList");
    //   if (controller.isLastListsEmpty) {
    //     _buildEmptyResults(context);
    //   }

    //   return SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         const SizedBox(
    //           height: global_constants.defaultHeight,
    //         ),
    //         if (lastSearchWishList.isNotEmpty) ...[
    //           const Center(
    //             child: Text("Users"),
    //           ),
    //           _userListViewBuilder(lastSearchUserList),
    //         ],
    //         if (lastSearchWishList.isNotEmpty) ...[
    //           const Divider(),
    //           const Center(
    //             child: Text("Wishes"),
    //           ),
    //           const SizedBox(
    //             height: global_constants.defaultHeight,
    //           ),
    //           _wishListViewBuilder(lastSearchWishList),
    //         ],
    //       ],
    //     ),
    //   );
    // });

    _waus.setSuggestions();

    return Obx(() {
      if (_waus.isSuggestionsLoad.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // if (controller) {
      //   return const Center(
      //     child: Text("Something went wrong..."),
      //   );
      // }

      final lastSearchUserList = _waus.suggestionsSearchUserList;
      final lastSearchWishList = _waus.suggestionsSearchWishList;
      // final lastSearchUserList = _waus.suggestionsUserList;
      // final lastSearchWishList = _waus.suggestionsWishList;

      print("buildSuggestions - lastSearchUserList : $lastSearchUserList");
      print("buildSuggestions - lastSearchWishList : $lastSearchWishList");
      if (_waus.isLastListsEmpty) {
        _buildEmptySuggestions(context);
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: global_constants.defaultHeight,
            ),
            if (lastSearchWishList.isNotEmpty) ...[
              const Center(
                child: Text("Users"),
              ),
              _userListViewBuilder(lastSearchUserList),
            ],
            if (lastSearchWishList.isNotEmpty) ...[
              const Divider(),
              const Center(
                child: Text("Wishes"),
              ),
              const SizedBox(
                height: global_constants.defaultHeight,
              ),
              _wishListViewBuilder(lastSearchWishList),
            ],
          ],
        ),
      );
    });
  }

  void _tapOnSearchWish(int id) {
    _waus.tapOnSearchWish(id);
    close(Get.context!, null);
  }

  void _removeFromLastSearchWishList(int id) {
    _waus.removeFromSuggestionsSearchWishList(id);
    // TODO: BUG - NOT UPDATING UI
  }

  _tapOnSearchUser(String id) {
    _waus.tapOnSearchUser(id);
  }

  _removeFromLastSearchUserList(String id) {
    _waus.removeFromSuggestionsSearchUserList(id);
    // TODO: BUG - NOT UPDATING UI
  }
}
