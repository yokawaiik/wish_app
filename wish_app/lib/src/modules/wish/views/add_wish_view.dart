import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/widgets/default_text_field.dart';

import '../controllers/add_wish_controller.dart';

import "../utils/add_wish_validators.dart" as add_wish_validators;
import "../../../utils/validators.dart" as validators;

// class AddWishView extends StatelessWidget {
class AddWishView extends GetView<AddWishController> {
  static const String routeName = "/add-wish";
  AddWishView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(controller.isEdit.value ? "Edit wish" : "New wish"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // In another file: add_wish_image.dart
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      width: double.infinity,
                      height: Get.height / 3,
                      child: InkWell(
                        // onTap: controller.pickImage,
                        onTap: controller.pickImage,
                        child: controller.wishForm.value.hasImage
                            ? (controller.wishForm.value.image != null
                                ? Image.file(
                                    controller.wishForm.value.image!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    controller.wishForm.value.imageUrl!,
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
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          DefaultTextField(
                            controller: controller.titleController,
                            validator: (value) =>
                                validators.onlyNumbersAndLettersCheck(
                              value,
                              "Title",
                              minLength: 5,
                              isRequired: true,
                            ),
                            prefixIcon: Icon(Icons.title),
                            onChanged: (v) {
                              controller.wishForm.value.title = v;
                            },
                            maxLength: 100,
                            labelText: "Title",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DefaultTextField(
                            prefixIcon: Icon(Icons.description),
                            validator: (value) =>
                                validators.onlyNumbersAndLettersCheck(
                              value,
                              "Description",
                            ),
                            controller: controller.descriptionController,
                            onChanged: (v) {
                              controller.wishForm.value.description = v;
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
                            validator: (value) => add_wish_validators.checkLink(
                              value,
                            ),
                            controller: controller.linkController,
                            prefixIcon: Icon(Icons.link),
                            onChanged: (v) {
                              controller.wishForm.value.link = v;
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
                                onPressed: (controller.isLoading.value
                                    ? null
                                    : (controller.isEdit.value
                                        ? controller.saveWish
                                        : controller.addWish)),
                                child: SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: Center(
                                    child: controller.isLoading.value
                                        ? CircularProgressIndicator()
                                        : Text(
                                            controller.isEdit.value
                                                ? "Save"
                                                : "Create",
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.fontSize,
                                            ),
                                          ),
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
            ),
          ),
          if (controller.isWishLoading.value) ...[
            Container(
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
          ],
        ],
      );
    });
  }
}
