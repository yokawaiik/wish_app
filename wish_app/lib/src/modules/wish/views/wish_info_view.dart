import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/wish/controllers/wish_info_controller.dart';

import '../../../widgets/icon_title_button.dart';

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
        title: Text("Wish info"),
      ),
      body: Obx(
        () {
          final currentWish = controller.currentWish.value!;

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                width: double.infinity,
                height: Get.height / 3,
                child: InkWell(
                  // onTap: null,
                  child: controller.currentWish.value!.hasImage
                      ? Image.network(
                          controller.currentWish.value!.imageUrl!,
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
                    Text(
                      currentWish.title,
                      style: TextStyle(
                          fontSize: Get.textTheme.headline5!.fontSize),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (!currentWish.isCurrentUser)
                      IconTitleButton(
                        onPressed: () => controller.addToFavorites(),
                        icon: const Icon(Icons.favorite),
                        title: const Text("Like"),
                      ),
                    if (currentWish.isCurrentUser) ...[
                      IconTitleButton(
                        onPressed: () => controller.editTheWish(),
                        icon: const Icon(Icons.edit),
                        title: const Text("Edit"),
                      ),
                      IconTitleButton(
                        onPressed: () => controller.deleteTheWish(),
                        icon: const Icon(Icons.delete),
                        title: const Text("Delete"),
                      )
                    ],
                    IconTitleButton(
                      onPressed: () => controller.shareTheWish(),
                      icon: const Icon(Icons.share),
                      title: const Text("Share"),
                    )
                  ],
                ),
              ),
              Divider(),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // ListTile(
                  //   // leading: Text("Title"),
                  //   leading: Icon(Icons.title),
                  //   title: Text(currentWish.title),
                  // ),
                  if (currentWish.description != null)
                    ListTile(
                      // leading: Text("Description"),
                      leading: Icon(Icons.description),
                      title: Text(currentWish.description!),
                    ),
                  if (currentWish.link != null)
                    ListTile(
                      // leading: Text("Link"),
                      leading: Icon(Icons.link),
                      title: Text(currentWish.link!),
                    ),
                  // todo: add author name with link to its profile
                  // if (currentWish.author != null)
                  //   ListTile(
                  //     leading: Text("Author"),
                  //     title: Text(currentWish.author!),
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
