import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/widgets/bouncing_icon_button.dart';
import 'package:wish_app/src/widgets/wish_grid_item.dart';
import '../../../models/wish.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_main_controller.dart';

import '../../../constants/global_constants.dart' as global_constants;
import '../../../theme/theme_wish_app.dart' as theme_wish_app;

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
                  icon: Icon(
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
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: theme_wish_app.favoriteColor,
                    ),
                    title: Text("Add to favorites"),
                    onTap: () => controller.addToFavorites(wish.id),
                  ),
                ListTile(
                  leading: Icon(Icons.send),
                  title: Text("Share"),
                  onTap: controller.shareWish,
                ),
                if (wish.createdBy.isCurrentUser)
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                    onTap: () => controller.actionDeleteWish(wish),
                  ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("See profile"),
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
          title: Text("Home"),
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
                  Container(
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
    // final mediaQuery = Get.mediaQuery;
    // final size = mediaQuery.size;
    // final gridItemHeight = 500.0;
    // todo, optional: implement grid to desktop

    return MasonryGridView.builder(
      padding: EdgeInsets.all(global_constants.paddingInsideGridView),
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
}
