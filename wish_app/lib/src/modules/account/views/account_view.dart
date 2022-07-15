import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/widget/button_counter_title.dart';
import '../../global/constants/global_constants.dart' show defaultPadding;
import '../../global/constants/account_constants.dart' show skeletonItemCount;
import '../../global/models/wish.dart';
import '../../global/services/user_service.dart';
import '../../global/widgets/account_user_avatar.dart';
import '../../global/widgets/skeleton.dart';
import '../../global/widgets/wish_card.dart';
import '../../global/widgets/wish_card_skeleton.dart';

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
                  // if (userService.isUserAuthenticated.value) ...[
                  if (controller.isCurrentUser.value) ...[
                    ListTile(
                      leading: const Icon(Icons.create),
                      // title: const Text("Create new wish"),
                      title: Text(
                          "account_view_list_tile_text_create_new_wish".tr),
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
                      leading: const Icon(Icons.person),
                      title: Text("account_view_list_tile_text_my_account".tr),
                      onTap: controller.goToMyAccountPage,
                    ),

                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(userService.isUserAuthenticated.value
                        // ? "Sign Out"
                        // : "Log In"),
                        ? "account_view_list_tile_text_is_user_authenticated_true"
                            .tr
                        : "account_view_list_tile_text_is_user_authenticated_false"
                            .tr),
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
                icon: const Icon(Icons.menu),
                onPressed: () => isLoading ? null : _showMenu(context),
              ),
            ],
          ),
          floatingActionButton: controller.isUserAuthenticated.value
              ? FloatingActionButton(
                  heroTag: UniqueKey(),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  clipBehavior: Clip.hardEdge,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: controller.createWish,
                )
              : const SizedBox.shrink(),
          body: NestedScrollView(
              controller: controller.wishGridController,
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
                                      key: ValueKey(userAccount!
                                          .imageUrl), // ? info: to update widget image

                                      defaultColor: colorScheme.primary,
                                      userHexColor: userAccount.userColor,
                                      imageUrl: userAccount.imageUrl,
                                      radius: 50,
                                    ),
                              Row(
                                children: [
                                  ButtonCounterTitle(
                                    onPressed: null,
                                    // title: "Wishes",
                                    title:
                                        "account_view_button_counter_title_wishes"
                                            .tr,
                                    counter: isLoading
                                        ? null
                                        : userAccount?.countOfWishes.toString(),
                                    skeleton: Skeleton(
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ButtonCounterTitle(
                                    key: const Key("Followers"),
                                    onPressed: null,
                                    // title: "Followers",
                                    title:
                                        "account_view_button_counter_title_followers"
                                            .tr,
                                    counter: isLoading
                                        ? null
                                        : userAccount?.countOfsubscribers
                                            .toString(),
                                    skeleton: Skeleton(
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ButtonCounterTitle(
                                    key: const Key("Following"),
                                    onPressed: null,
                                    // title: "Following",
                                    title:
                                        "account_view_button_counter_title_following"
                                            .tr,
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
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Row(
                            children: [
                              if (isLoading)
                                // if (true)
                                Skeleton.elevatedButton()
                              else ...[
                                if (controller.isUserAuthenticated.value) ...[
                                  if (userAccount!.isCurrentUser)
                                    ElevatedButton(
                                      onPressed: controller.editProfile,
                                      child: Text(
                                        // "Edit profile",
                                        "account_view_elevated_button_text_edit_profile"
                                            .tr,
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
                                                  // // ? "Unfollow"
                                                  // : "Follow",
                                                  ? "account_view_elevated_button_text_has_subscribe_true"
                                                      .tr
                                                  : "account_view_elevated_button_text_has_subscribe_false"
                                                      .tr,
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
    required ScrollController controller,
    required Function onTap,
  }) {
    final colorScheme = Get.theme.colorScheme;

    var sliverGridDelegateWithFixedCrossAxisCount =
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: GetPlatform.isMobile ? 1 : 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 3 / 1, //? info: for height
    );

    if (isLoading) {
      return Expanded(
        child: GridView.builder(
          physics: const ClampingScrollPhysics(),
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

  // ? info: Pass this method to an onTapDown parameter to record the tap position.
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
            leading: const Icon(Icons.work),
            title: Text('account_view_popup_menu_item_title_delete_wish'.tr),
          ),
        )
      ],
      context: context,
    );
  }
}
