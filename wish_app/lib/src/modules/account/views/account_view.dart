import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/models/account_arguments.dart';
import 'package:wish_app/src/modules/account/widget/button_counter_title.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/widgets/account_user_avatar.dart';
import 'package:wish_app/src/widgets/skeleton.dart';
import 'package:wish_app/src/widgets/wish_card.dart';

import '../../../widgets/wish_card_skeleton.dart';

import '../../../constants/global_constants.dart' show defaultPadding;
import '../../../constants/account_constants.dart' show skeletonItemCount;

class AccountView extends GetView<AccountController> {
  static const String routeName = "/account";

  @override
  final String? tag;

  AccountView({
    this.tag,
    Key? key,
  }) : super(key: key);

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
                    onPressed: () => controller.closeModalBottomSheet(),
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
                  // if (userService.isUserAuthenticated.value) ...[
                  if (controller.isCurrentUser.value) ...[
                    ListTile(
                      leading: Icon(Icons.create),
                      title: Text("Create new wish"),
                      onTap: controller.createWish,
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.person),
                    //   title: Text("Exit"),
                    //   onTap: controller.exit,
                    // )
                  ],
                  if (userService.isUserAuthenticated.value &&
                      !controller.isCurrentUser.value)
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("My Account"),
                      onTap: controller.goToMyAccountPage,
                    ),

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(userService.isUserAuthenticated.value
                        ? "Sign Out"
                        : "Log In"),
                    onTap: () => (controller.isCurrentUser.value
                        ? controller.signOut()
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
        final isSubscribing = controller.isSubscribing.value;

        return Scaffold(
          appBar: AppBar(
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
              controller: controller.wishGridController,
              // controller: ,
              // controller: _nestedScrollViewController,
              // floatHeaderSlivers: true,
              // physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (_c, _hsb) {
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
                                    key: Key("Followers"),
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
                                    key: Key("Following"),
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
                              else ...[
                                if (controller.isUserAuthenticated.value) ...[
                                  if (userAccount!.isCurrentUser)
                                    // todo: Edit profile
                                    ElevatedButton(
                                      onPressed: controller.editProfile,
                                      child: Text(
                                        "Edit profile",
                                      ),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: isSubscribing
                                          ? null
                                          : controller.toggleSubscription,
                                      child: isSubscribing
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child:
                                                  CircularProgressIndicator())
                                          : Text(
                                              userAccount.hasSubscribe
                                                  ? "Unfollow"
                                                  : "Follow",
                                            ),
                                    ),
                                ]
                              ]
                              // followButton
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
                      isLoading: isLoading,
                      wishList: wishList,
                      // context: context,
                      controller: controller.wishGridController,
                      onTap: controller.goToWishInfo,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget _buildWishGrid({
    int? countOfWishes,
    required RxList<Wish> wishList,
    required bool isLoading,
    // required BuildContext context,
    required ScrollController controller,
    required Function onTap,
  }) {
    // final colorScheme = Theme.of(context).colorScheme;
    final colorScheme = Get.theme.colorScheme;

    var sliverGridDelegateWithFixedCrossAxisCount =
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: GetPlatform.isMobile ? 1 : 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 3 / 1, // for height
    );

    if (isLoading) {
      return Expanded(
        child: GridView.builder(
          // physics: const AlwaysScrollableScrollPhysics(),
          // physics: NeverScrollableScrollPhysics(),
          physics: ClampingScrollPhysics(),
          gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
          itemCount: skeletonItemCount,
          itemBuilder: (_, i) {
            return const WishCardSkeleton();
          },
        ),
      );
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
            // physics: NeverScrollableScrollPhysics(),
            gridDelegate: sliverGridDelegateWithFixedCrossAxisCount,
            itemCount: countOfWishes,
            itemBuilder: (ctx, i) {
              if (i < wishList.length) {
                final wish = wishList[i];

                return WishCard(
                  wish,
                  onTap: () => onTap(wish.id),
                  onTapDown: _storePosition,
                  onLongPress: () => _showPopupMenu(ctx, wish.id),
                );
              } else {
                return const WishCardSkeleton();
              }
            }),
      );
    }
  }

  Offset? _tapPosition;

  /// Pass this method to an onTapDown parameter to record the tap position.
  void _storePosition(TapDownDetails details) =>
      _tapPosition = details.globalPosition;

  void _showPopupMenu(
    BuildContext context,
    int id,
  ) {
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      position: RelativeRect.fromLTRB(
        _tapPosition!.dx,
        _tapPosition!.dy,
        overlay.size.width - _tapPosition!.dx,
        overlay.size.height - _tapPosition!.dy,
      ),
      items: [
        PopupMenuItem(
          onTap: () => controller.removeWish(id),
          child: ListTile(
            leading: Icon(Icons.work),
            title: Text('Delete wish'),
          ),
        )
      ],
      context: context,
    );
  }
}
