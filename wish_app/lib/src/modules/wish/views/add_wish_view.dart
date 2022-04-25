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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                // border: Border.all(),
              ),
              width: double.infinity,
              height: Get.height / 3,
              child: Icon(
                Icons.image,
                size: 100,
              ),
            ),
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
