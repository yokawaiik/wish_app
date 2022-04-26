import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/widgets/default_text_field.dart';

import '../controllers/add_wish_controller.dart';

class AddWishView extends GetView<AddWishController> {
  static const String routeName = "/add-wish";
  AddWishView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // todo: edit wish
        title: Text("New wish"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // In another file: add_wish_image.dart
            GetBuilder<AddWishController>(builder: (addWishController) {
              print("GetBuilder");
              print(controller.wishForm.image);
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                width: double.infinity,
                height: Get.height / 3,
                child: InkWell(
                  onTap: controller.pickImage,
                  child: controller.wishForm.hasImage
                      ? (controller.wishForm.image != null
                          ? Image.file(
                              controller.wishForm.image!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              controller.wishForm.imageUrl!,
                              fit: BoxFit.cover,
                            ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 100,
                            ),
                            Icon(
                              Icons.arrow_right_alt,
                              size: 100,
                            ),
                            Icon(
                              Icons.image,
                              size: 100,
                            ),
                          ],
                        ),
                ),
              );
            }),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  DefaultTextField(
                    prefixIcon: Icon(Icons.title),
                    initialValue: controller.wishForm.title,
                    onChanged: (v) {
                      controller.wishForm.title = v;
                    },
                    maxLength: 100,
                    labelText: "Title",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    initialValue: controller.wishForm.description,
                    onChanged: (v) {
                      controller.wishForm.description = v;
                    },
                    minLines: 1,
                    maxLines: 15,
                    maxLength: 600,
                    labelText: "Description",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    initialValue: controller.wishForm.link,
                    prefixIcon: Icon(Icons.link),
                    onChanged: (v) {
                      controller.wishForm.link = v;
                    },
                    minLines: 1,
                    maxLines: 15,
                    maxLength: 1000,
                    labelText: "Link",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: controller.addWish,
                        child: Text(
                          "Create",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.fontSize,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
