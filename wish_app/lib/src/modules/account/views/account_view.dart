import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/widget/button_counter_title.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/widgets/account_user_avatar.dart';
import 'package:wish_app/src/widgets/skeleton.dart';

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

    return Obx(
      () {
        final userAccount = controller.userAccount.value;
        final isLoading = controller.isLoading.value;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: Get.back,
            ),
            // todo: change it
            // title: isLoading
            title: true
                ? Skeleton(
                    height: textTheme.bodyText2!.fontSize,
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
                  padding:
                      // const EdgeInsets.symmetric(vertical: , horizontal: 20),
                      const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // todo: change
                      // isLoading
                      true
                          ? Skeleton.round(radius: 50)
                          : AccountUserAvatar(
                              defaultColor:
                                  Theme.of(context).colorScheme.primary,
                              userHexColor: userAccount!.userColor,
                              imageUrl: userAccount.imageUrl,
                              radius: 50,
                              // skeleton: Skeleton(
                              //   height: 50,
                              //   width: 50,
                              // ),
                              // isLoading: isLoading,
                            ),
                      Row(
                        children: [
                          ButtonCounterTitle(
                            onPressed: null,
                            title: "Wishes",
                            counter: null,
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
                            counter: null,
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
                            counter: null,
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
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // todo: change it
                      // if (isLoading)
                      if (true)
                        Skeleton.elevatedButton()
                      else
                        userAccount!.isCurrentUser
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
                // todo: change it
                // if (isLoading) ...[
                if (true) ...[
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    children: [
                      ...List<int>.filled(9, 1)
                          .map((item) => Skeleton.hardCorners())
                          .toList()
                    ],
                  ),
                ]
                // todo: redo it
                else ...[
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    children: [
                      ...List<int>.filled(9, 1)
                          .map((item) => Skeleton.hardCorners())
                          .toList()
                    ],
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
