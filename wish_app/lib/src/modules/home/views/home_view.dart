import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/grid_wish_item.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  static const String routeName = "/home";
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // calculate size for items
    final size = MediaQuery.of(context).size;
    const spacing = 10.0;
    final double gridItemHeight = (size.height -
        kBottomNavigationBarHeight -
        kToolbarHeight -
        (spacing * 2 + 10));
    final double gridItemWidth = size.width;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshWishList();
        },
        child: Obx(
          () => controller.homeWishList.isNotEmpty
              ? GridView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: (gridItemWidth / gridItemHeight),
                  ),
                  itemCount: controller.homeWishList.length,
                  itemBuilder: (ctx, i) {
                    return GridWishItem(
                      wish: controller.homeWishList[i],
                      gridItemHeight: gridItemHeight,
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
        ),
      ),
      floatingActionButton: Obx(
        () => controller.isUserAuthenticated.value
            ? FloatingActionButton(
                child: Icon(Icons.add_box),
                clipBehavior: Clip.hardEdge,
                onPressed: controller.addNewWish,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
