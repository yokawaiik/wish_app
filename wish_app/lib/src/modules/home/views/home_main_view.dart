import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/services/user_service.dart';
import '../../../models/wish.dart';
import '../../../widgets/grid_wish_item.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_main_controller.dart';

class HomeMainView extends GetView<HomeMainController> {
  static const String routeName = "/home/main";
  HomeMainView({Key? key}) : super(key: key);

  void _showModalBottomSheet(
    BuildContext context,
    Wish wish,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = Get.find<UserService>();

    // calculate size for items
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final double gridItemHeight =
        (size.height - (kBottomNavigationBarHeight + kToolbarHeight + 40));

    // final double gridItemWidth = size.width;

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
                    ? GridView.builder(
                        // ? ListView.builder(
                        controller: controller.scrollController,
                        // padding: const EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: gridItemHeight,
                        ),

                        itemCount: controller.homeWishList.length,
                        itemBuilder: (ctx, i) {
                          final wish = controller.homeWishList[i];

                          return GridWishItem(
                            wish: controller.homeWishList[i],
                            gridItemHeight: gridItemHeight,
                            onPressedMore: () {
                              _showModalBottomSheet(
                                context,
                                wish,
                              );
                            },
                            onLongPress: () {
                              _showModalBottomSheet(
                                context,
                                wish,
                              );
                            },
                            clickOnAuthor: () => controller.seeProfile(wish),
                            clickOnWish: () =>
                                controller.onClickWishItem(wish.id),
                            onPressedAddToFavorites: controller.addToFavorites,
                            onPressedShare: controller.shareWish,
                          );
                        },
                      )
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
            return controller.userService.isUserAuthenticated.value
                ? FloatingActionButton(
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
}
