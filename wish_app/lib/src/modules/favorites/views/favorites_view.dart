import 'dart:ui';

import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/favorites/controllers/favorites_controllers.dart';

import '../../global/models/wish.dart';
import '../../global/widgets/wish_medium_card.dart';
import '../../global/widgets/wish_medium_card_skeleton.dart';

class FavoritesView extends GetView<FavoritesController> {
  static const routeName = "/favorites";
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final countOfFavorites = controller.countOfFavorites.value;
          final favoritesWishList = controller.favoritesWishList;

          return countOfFavorites == 0
              ? _buildEmpty()
              : _buildGridView(countOfFavorites, favoritesWishList);
        },
      ),
    );
  }

  Widget _buildGridView(int countOfFavorites, RxList<Wish> favoritesWishList) {
    // ? info. Calculate size: mobile / computer
    final double maxCrossAxisExtent = GetPlatform.isMobile ? 600 : 600;
    final double mainAxisExtent = GetPlatform.isMobile ? 400 : 400;
    final double imageHeight = GetPlatform.isMobile ? 200 : 200;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: RefreshIndicator(
            onRefresh: controller.refreshFavorites,
            child: GridView.builder(
                controller: controller.favoriteWishGridController,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  mainAxisExtent: mainAxisExtent,
                ),
                itemCount: countOfFavorites,
                itemBuilder: (ctx, i) {
                  if (i < favoritesWishList.length) {
                    final wish = favoritesWishList[i];
                    return WishMediumCard(
                      key: ValueKey(i),
                      wish: wish,
                      imageHeight: imageHeight,
                      hasActions: true,
                      onCardTap: () => controller.onCardTap(wish.id),
                      toggleFavorite: () => controller.toggleFavorite(wish.id),
                      // tapOnMore: () => _tapOnMore(wish),
                      tapOnMore: () => _snowModalBottomSheetMenu(ctx, wish),
                      onLongPress: () => _snowModalBottomSheetMenu(ctx, wish),
                    );
                  } else {
                    return WishMediumCardSkeleton(
                      key: ValueKey(i),
                      imageHeight: imageHeight,
                      hasActions: true,
                    );
                  }
                }),
          ),
        )
      ],
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: controller.refreshFavorites,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Get.theme.colorScheme.secondary,
                          size: 80,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        const Text(
                          Emojis.thinkingFace,
                          textScaleFactor: 8,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You can save founded wishes here...",
                      style: TextStyle(
                          fontSize: Get.theme.textTheme.headline5!.fontSize),
                    ),
                  ],
                ),
                if (controller.wasFirstLoad.value) ...[
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
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _snowModalBottomSheetMenu(BuildContext context, Wish wish) {
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
                  // ListTile(
                  //   leading: Icon(Icons.send),
                  //   title: Text("Share"),
                  //   onTap: controller.shareWish,
                  // ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Remove from favorites"),
                    onTap: () => controller.removeFromFavorite(wish.id),
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
}
