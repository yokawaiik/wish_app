import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/widget/button_counter_title.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/widgets/account_user_avatar.dart';
import 'package:wish_app/src/widgets/skeleton.dart';
import 'package:wish_app/src/widgets/wish_card.dart';

import '../../../widgets/wish_card_skeleton.dart';

import '../../../constants/global_constants.dart' show defaultPadding;
import '../../../constants/account_constants.dart' show skeletonItemCount;

class AccountView extends GetView<AccountController> {
  static const String routeName = "/account";
  const AccountView({Key? key}) : super(key: key);

  void _showMenu(
    BuildContext context,
  ) {
    final userService = Get.find<UserService>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
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
                  if (userService.isUserAuthenticated.value) ...[
                    ListTile(
                      leading: Icon(Icons.create),
                      title: Text("Create new wish"),
                      onTap: () => controller.createWish(),
                    ),
                  ],
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(userService.isUserAuthenticated.value
                        ? "Exit"
                        : "Log In"),
                    onTap: () => (userService.isUserAuthenticated.value
                        ? controller.exit()
                        : controller.goToLoginPage()),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () {
        final userAccount = controller.userAccount.value;
        final wishList = controller.wishList;
        final isLoading = controller.isLoading.value;

        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back_ios_new),
            //   onPressed: Get.back,
            // ),
            title: isLoading
                // title: true
                ? Skeleton(
                    height: defaultPadding,
                    width: 200,
                  )
                : Text(userAccount!.login),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => isLoading ? null : _showMenu(context),
              ),
            ],
          ),
          floatingActionButton: Obx(
            () => controller.isUserAuthenticated.value
                ? FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    clipBehavior: Clip.hardEdge,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: controller.createWish,
                  )
                : SizedBox.shrink(),
          ),
          body: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isLoading
                                  // true
                                  ? Skeleton.round(radius: 50)
                                  : AccountUserAvatar(
                                      defaultColor: colorScheme.primary,
                                      userHexColor: userAccount!.userColor,
                                      imageUrl: userAccount.imageUrl,
                                      radius: 50,
                                    ),
                              Row(
                                children: [
                                  ButtonCounterTitle(
                                    onPressed: null,
                                    title: "Wishes",
                                    counter: isLoading
                                        ? null
                                        : userAccount?.countOfWishes.toString(),
                                    skeleton: Skeleton(
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ButtonCounterTitle(
                                    onPressed: null,
                                    title: "Followers",
                                    counter: isLoading
                                        ? null
                                        : userAccount?.countOfsubscribers
                                            .toString(),
                                    skeleton: Skeleton(
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ButtonCounterTitle(
                                    onPressed: null,
                                    title: "Following",
                                    counter: isLoading
                                        ? null
                                        : userAccount?.countOfSubscribing
                                            .toString(),
                                    skeleton: Skeleton(
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Row(
                            children: [
                              if (isLoading)
                                // if (true)
                                Skeleton.elevatedButton()
                              else
                                userAccount!.isCurrentUser
                                    // todo: Edit profile
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Edit profile",
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Follow"),
                                      ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: controller.refreshAccountData,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildWishGrid(
                        countOfWishes: userAccount?.countOfWishes,
                        // countOfWishes: 0,
                        isLoading: isLoading,
                        wishList: wishList,
                        context: context,
                        controller: controller.wishGridController),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget _buildWishGrid(
      {int? countOfWishes,
      required RxList<Wish> wishList,
      required bool isLoading,
      required BuildContext context,
      required ScrollController controller}) {
    final colorScheme = Theme.of(context).colorScheme;

    var sliverGridDelegateWithFixedCrossAxisCount =
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: GetPlatform.isMobile ? 1 : 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 3 / 1, // for height
    );

    print("_buildGridView - countOfWishes : ${countOfWishes}");
    print("_buildGridView - isLoading : $isLoading");
    print("_buildGridView - wishList?.length : ${wishList.length}");

    // todo: remove it
    // var testList = List.filled(2, 1, growable: true);

    if (isLoading) {
      return Expanded(
        child: GridView.builder(
          gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
          itemCount: skeletonItemCount,
          itemBuilder: (_, i) {
            return const WishCardSkeleton();
          },
        ),
      );
      // } else if (countOfWishes == 0 || wishList.isEmpty) {
    } else if (wishList.isEmpty || countOfWishes == 0) {
      return Expanded(
        child: Center(
          child: Icon(
            Icons.question_mark,
            color: colorScheme.primary,
            size: 100,
          ),
        ),
      );
    } else {
      return Expanded(
        child: GridView.builder(
          controller: controller,
          gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
          itemCount: countOfWishes,
          itemBuilder: (_, i) {
            // if (i < (countOfWishes!)) {
            if (i < (wishList.length)) {
              return WishCard(wishList[i]);
            } else {
              return const WishCardSkeleton();
            }
          },
        ),
      );
    }
  }
}
