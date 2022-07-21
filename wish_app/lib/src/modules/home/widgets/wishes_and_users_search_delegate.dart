import 'package:flutter/material.dart';
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

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                close(context, null);
              },
            )
          : IconButton(
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
      return Center(
        child: Text("hm_wausd_br_query_empty_center_text".tr),
      );
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
            return Center(
              child: Text("hm_wausd_error_center_text".tr),
            );
          }

          final searchUserList = _waus.searchUserList;
          final searchWishList = _waus.searchWishList;

          if (_waus.isListsEmpty) {
            return Center(
              child: Text("hm_wausd_br_list_empty_center_text".tr),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: global_constants.defaultHeight,
                ),
                if (searchUserList.isNotEmpty) ...[
                  Center(
                    child: Text("hm_wausd_result_category_users".tr),
                  ),
                  _userListViewBuilder(
                    searchUserList,
                    slidableEnabled: false,
                  ),
                  const Divider(),
                ],
                if (searchWishList.isNotEmpty) ...[
                  Center(
                    child: Text("hm_wausd_result_category_wishes".tr),
                  ),
                  const SizedBox(
                    height: global_constants.defaultHeight,
                  ),
                  _wishListViewBuilder(
                    searchWishList,
                    slidableEnabled: false,
                  ),
                ],
              ],
            ),
          );
        });
  }

  ListView _wishListViewBuilder(
    List<LightWish> searchWishList, {
    bool slidableEnabled = true,
    void Function(BuildContext, int id)? slidableRemoveMethod,
  }) {
    final colorScheme = Get.theme.colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchWishList.length,
      itemBuilder: (context, index) {
        final wish = searchWishList[index];

        return SearchListTile(
          enabled: slidableEnabled,
          key: ValueKey(wish.id),
          onTap: () => _tapOnSearchWish(wish.id),
          slideActionOnPressedDelete: (context) {
            if (slidableRemoveMethod != null) {
              slidableRemoveMethod(context, wish.id);
            }
          },
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
    void Function(BuildContext, String id)? slidableRemoveMethod,
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
          slideActionOnPressedDelete: (context) {
            if (slidableRemoveMethod != null) {
              slidableRemoveMethod(context, user.id);
            }
          },
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: _waus.setSuggestions(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("hm_wausd_error_center_text".tr),
            );
          }

          final lastSearchUserList = _waus.suggestionsSearchUserList;
          final lastSearchWishList = _waus.suggestionsSearchWishList;

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            if (lastSearchUserList.isEmpty && lastSearchWishList.isEmpty) {
              return Center(
                child: Text("hm_wausd_bs_suggestions_lists_empty".tr),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: global_constants.defaultHeight,
                  ),
                  if (lastSearchUserList.isNotEmpty) ...[
                    Center(
                      child: Text("hm_wausd_result_category_users".tr),
                    ),
                    _userListViewBuilder(
                      lastSearchUserList,
                      slidableRemoveMethod: (_, id) {
                        setState(
                          () {
                            _removeFromLastSearchUserList(id);
                          },
                        );
                      },
                    ),
                  ],
                  if (lastSearchUserList.isNotEmpty &&
                      lastSearchWishList.isNotEmpty) ...[
                    const Divider(),
                  ],
                  if (lastSearchWishList.isNotEmpty) ...[
                    Center(
                      child: Text("hm_wausd_result_category_wishes".tr),
                    ),
                    const SizedBox(
                      height: global_constants.defaultHeight,
                    ),
                    _wishListViewBuilder(
                      lastSearchWishList,
                      slidableRemoveMethod: (_, id) {
                        setState(
                          () {
                            _removeFromLastSearchWishList(id);
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          });
        });
  }

  void _tapOnSearchWish(int id) {
    final wishInfoArguments = _waus.tapOnSearchWish(id);
    close(Get.context!, wishInfoArguments);
  }

  void _removeFromLastSearchWishList(int id) async {
    _waus.removeFromSuggestionsSearchWishList(id);
  }

  void _tapOnSearchUser(String id) async {
    final accountArguments = _waus.tapOnSearchUser(id);
    close(Get.context!, accountArguments);
  }

  void _removeFromLastSearchUserList(String id) async {
    _waus.removeFromSuggestionsSearchUserList(id);
  }
}
