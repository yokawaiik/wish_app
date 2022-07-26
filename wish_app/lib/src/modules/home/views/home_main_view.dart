import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/wish/models/wish_info_arguments.dart';

import '../../global/models/wish.dart';
import '../../global/widgets/wish_grid_item.dart';
import '../../wish/views/wish_info_view.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_main_controller.dart';

import '../../global/constants/global_constants.dart' as global_constants;
import '../../global/theme/theme_wish_app.dart' as theme_wish_app;
import '../widgets/wishes_and_users_search_delegate.dart';

import '../constants/router_constants.dart' as router_constants;

class HomeMainView extends GetView<HomeMainController> {
  static const String routeName = "/home/main";
  const HomeMainView({Key? key}) : super(key: key);

  void _showModalBottomSheet(
    Wish wish,
  ) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Get.back(closeOverlays: true),
                  icon: const Icon(
                    Icons.close,
                    size: 36,
                  ),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
                if (!wish.createdBy.isCurrentUser)
                  if (!wish.isFavorite)
                    ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: theme_wish_app.favoriteColor,
                      ),
                      title: Text("fm_hmv_bs_lv_add_to_favorites".tr),
                      onTap: () => controller.addToFavorites(wish.id),
                    )
                  else
                    ListTile(
                      leading: const Icon(
                        Icons.favorite_outline,
                        color: theme_wish_app.unFavoriteColor,
                      ),
                      title: Text("fm_hmv_bs_lv_delete_from_favorites".tr),
                      onTap: () => controller.deleteFromFavorites(wish.id),
                    )
                else ...[
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text("fm_hmv_bs_lv_delete".tr),
                    onTap: () => controller.actionDeleteWish(wish),
                  )
                ],
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("fm_hmv_bs_lv_see_profile".tr),
                  onTap: () => controller.seeProfile(wish),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.colorScheme.background,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Get.find<HomeController>().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _showSearch,
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshWishList();
          },
          child: Obx(
            () => Stack(
              children: [
                controller.homeWishList.isNotEmpty
                    ? _gridBuild()
                    : Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 150,
                        ),
                      ),
                if (controller.isDeleting.value) ...[
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(
          () {
            return controller.isUserAuthenticated.value
                ? FloatingActionButton(
                    heroTag: UniqueKey(),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    clipBehavior: Clip.hardEdge,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: controller.addNewWish,
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _gridBuild() {
    // todo, optional: implement grid to desktop

    return MasonryGridView.builder(
      padding: const EdgeInsets.all(global_constants.paddingInsideGridView),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: global_constants.paddingInsideGridView,
      crossAxisSpacing: global_constants.paddingInsideGridView,
      itemCount: controller.homeWishList.length,
      itemBuilder: (_, i) {
        final wish = controller.homeWishList[i];
        return WishGridItem(
          wish: wish,
          clickOnWish: () => controller.onClickWishItem(wish.id),
          onPressedMore: () => _showModalBottomSheet(wish),
          onLongPress: () => _showModalBottomSheet(wish),
        );
      },
    );
  }

  void _showSearch() async {
    final searchResult = await showSearch(
      context: Get.context!,
      delegate: WishesAndUsersSearchDelegate(),
    );

    if (searchResult is AccountArguments) {
      final hc = Get.find<HomeController>();

      await Get.toNamed(
        router_constants.homeAccountRouteName,
        id: hc.nestedKey,
        arguments: searchResult,
      );
    } else if (searchResult is WishInfoArguments) {
      await Get.toNamed(
        WishInfoView.routeName,
        arguments: searchResult,
      );
    }
  }
}
