import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/widget/button_counter_title.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/widgets/account_user_avatar.dart';
import 'package:wish_app/src/widgets/skeleton.dart';

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
        final wishList = controller.wishList.value;
        final isLoading = controller.isLoading.value;

        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back_ios_new),
            //   onPressed: Get.back,
            // ),
            // todo: change it
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                            counter: userAccount?.countOfWishes.toString(),
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
                            counter: userAccount?.countOfsubscribers.toString(),
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
                            counter: userAccount?.countOfSubscribing.toString(),
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
                // Divider(),
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
                                  // style: TextStyle(
                                  //   fontSize: textTheme.headline6!.fontSize,
                                  // ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                child: Text("Follow"),
                              )
                    ],
                  ),
                ),
                const Divider(),
                // if (true) ...[
                // Expanded(
                //   child: _buildWishGrid(
                //     countOfWishes: userAccount?.countOfWishes,
                //     isLoading: isLoading,
                //     wishList: wishList,
                //     context: context,
                //   ),
                // ),

                _buildWishGrid(
                  // countOfWishes: userAccount?.countOfWishes,
                  countOfWishes: 0,
                  isLoading: isLoading,
                  wishList: wishList,
                  context: context,
                ),

                // Expanded(
                //   child: Center(
                //     child: Text('None'),
                //   ),
                // )

                // todo: redo it
                // else ...[
                //   GridView.count(
                //     physics: const NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     crossAxisCount: 3,
                //     mainAxisSpacing: 1,
                //     crossAxisSpacing: 1,
                //     children: [
                //       ...List<int>.filled(9, 1)
                //           .map((item) => Skeleton.hardCorners())
                //           .toList()
                //     ],
                //   ),
                // ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWishGrid({
    int? countOfWishes,
    List<Wish>? wishList,
    required bool isLoading,
    required BuildContext context,
  }) {
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
    print("_buildGridView - wishList?.length : ${wishList?.length}");

    // todo: remove it
    var testList = List.filled(5, 1, growable: true);

    if (isLoading) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
        itemCount: skeletonItemCount,
        itemBuilder: (_, i) {
          return const WishCardSkeleton();
        },
      );
    } else {
      if (countOfWishes == 0) {
        // return Expanded(
        //   child: Center(
        //     child: Icon(
        //       Icons.question_mark,
        //       color: colorScheme.primary,
        //       size: 100,
        //     ),
        //   ),
        // );
        return Center(
          child: Icon(
            Icons.question_mark,
            color: colorScheme.primary,
            size: 100,
          ),
        );
      } else {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
          itemCount: countOfWishes,
          itemBuilder: (_, i) {
            // return WishCard(wishList![i]);
            // if (i == (wishList!.length - 1)) {
            print(
                'countOfWishes - $countOfWishes : testList.length - ${testList.length}');

            print('i - $i : testList.length - ${testList.length}');
            // if (i <= (testList.length - 1)) {
            if (i < (testList.length - 1)) {
              return Text(testList[i].toString());
            } else {
              return Text("No");
            }
          },
        );
      }
    }
  }
}
