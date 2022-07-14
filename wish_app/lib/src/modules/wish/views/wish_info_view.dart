import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/wish/controllers/wish_info_controller.dart';
import '../../global/constants/global_constants.dart' as global_constants;
import '../../global/widgets/icon_title_button.dart';
import '../../global/widgets/skeleton.dart';

class WishInfoView extends GetView<WishInfoController> {
  static const String routeName = "/wish-info";
  const WishInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final currentWish = controller.currentWish.value!;

    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(onPressed: onPressed, icon: icon)
        // ],
        // title: const Text("Wish info"),
        title: Text('wish_info_appbar_title'.tr),
      ),
      body: Obx(
        () {
          final currentWish = controller.currentWish.value;

          final isLoading = controller.status.isLoading;

          return Column(
            children: [
              if (isLoading)
                Skeleton.hardCorners(
                  width: double.infinity,
                  height: Get.height / 3,
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  width: double.infinity,
                  height: Get.height / 3,
                  child: InkWell(
                    // onTap: null,
                    child: currentWish!.hasImage
                        ? Image.network(
                            currentWish.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_center_outlined,
                                size: 100,
                              ),
                            ],
                          ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    isLoading
                        ? Skeleton(
                            height: global_constants.defaultPadding,
                            width: 200,
                          )
                        : Text(
                            currentWish!.title,
                            style: TextStyle(
                                fontSize: Get.textTheme.headline5!.fontSize),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // child: Row(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (isLoading) ...[
                          Skeleton.round(radius: 20),
                          Skeleton.round(radius: 20),
                          Skeleton.round(radius: 20),
                          Skeleton.round(radius: 20),
                          Skeleton.round(radius: 20),
                        ] else ...[
                          // if (!currentWish.createdBy.isCurrentUser)
                          //   IconTitleButton(
                          //     onPressed: () => controller.addToFavorites(),
                          //     icon: const Icon(Icons.favorite),
                          //     title: const Text("Like"),
                          //   ),
                          if (currentWish!.createdBy.isCurrentUser) ...[
                            IconTitleButton(
                              onPressed: () => controller.editTheWish(),
                              icon: const Icon(Icons.edit),
                              // title:  Text("Edit"),
                              title:
                                  Text("wish_info_icon_title_button_edit".tr),
                            ),
                            IconTitleButton(
                              onPressed: () => controller.deleteTheWish(),
                              icon: const Icon(Icons.delete),
                              // title:  Text("Delete"),
                              title:
                                  Text("wish_info_icon_title_button_delete".tr),
                            ),
                            // IconTitleButton(
                            //   onPressed: () => controller.shareTheWish(),
                            //   icon: const Icon(Icons.share),
                            //   title: const Text("Share"),
                            // )
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  if (isLoading)
                    ListTile(
                        // leading: Text("Description"),
                        leading: Icon(Icons.description),
                        title: Skeleton(
                          height: global_constants.defaultPadding,
                          width: 200,
                        ))
                  else ...[
                    if (currentWish!.description != null)
                      ListTile(
                        // leading: Text("Description"),
                        leading: Icon(Icons.description),
                        title: Text(currentWish.description!),
                      ),
                  ],

                  if (isLoading)
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Skeleton(
                        height: global_constants.defaultPadding,
                        width: 200,
                      ),
                    )
                  else ...[
                    if (currentWish!.link != null)
                      ListTile(
                        leading: Icon(Icons.link),
                        title: Text(currentWish.link!),
                      ),
                  ],

                  if (isLoading)
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Skeleton(
                        height: global_constants.defaultPadding,
                        width: 200,
                      ),
                    )
                  else ...[
                    if (!currentWish!.createdBy.isCurrentUser)
                      ListTile(
                        onTap: controller.seeProfile,
                        leading: Icon(Icons.person),
                        title: Text(currentWish.createdBy.login),
                      ),
                  ],

                  // if (currentWish.link != null)
                  //   ListTile(
                  //     // leading: Text("Link"),
                  //     leading: Icon(Icons.link),
                  //     title: Text(currentWish.link!),
                  //   ),
                  // if (!currentWish.createdBy.isCurrentUser)
                  //   ListTile(
                  //     onTap: controller.seeProfile,
                  //     leading: Icon(Icons.person),
                  //     title: Text(currentWish.createdBy.login),
                  //   ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
