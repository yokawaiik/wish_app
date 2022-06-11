import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/modules/wish/controllers/wish_info_controller.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';
import 'package:wish_app/src/modules/wish/service/add_wish_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import 'package:wish_app/src/services/user_service.dart';

// class AddWishController extends GetxController {
class AddWishController extends GetxController {
  var wishForm = WishForm().obs;

  final userService = Get.find<UserService>();

  var isLoading = RxBool(false);
  var isWishLoading = RxBool(false);
  var isEdit = RxBool(false);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  late final GlobalKey<FormState> formKey;

  @override
  void onInit() async {
    formKey = GlobalKey<FormState>();
    checkModeView();
    super.onInit();
  }

  bool validateFields() {
    return formKey.currentState!.validate();
  }

  // it changes curent mode for this screen: edit or add new
  void checkModeView() async {
    if (Get.arguments != null) {
      isEdit.value = Get.arguments["isEdit"] as bool? ?? false;
      // request wish
      if (isEdit.value) {
        // if not creator user wants to edit item
        final id = Get.arguments["id"] as int?;
        final isCurrentUser = Get.arguments["isCurrentUser"] as bool;

        if (!isCurrentUser) {
          // Get.offAndToNamed(HomeView.routeName);
          Get.offNamedUntil(NavigatorView.routeName, (route) => false);
          Get.snackbar("Error", "You are not a creator");
        }

        if (id == null) {
          // Get.offAndToNamed(NavigatorView.routeName);
          Get.offNamedUntil(NavigatorView.routeName, (route) => false);
          Get.snackbar("Error",
              "You want to edit wish but wish with this id doesn't exist or was deleted.");
          return;
        }
        // get the wish
        await getWIshForEdit(id);
      }
    } else {
      isWishLoading.value = false;
      // change(null, status: RxStatus.success());
    }
  }

  Future<void> getWIshForEdit(int id) async {
    try {
      // make status to loading
      isWishLoading.value = true;
      // change(null, status: RxStatus.loading());
      // isGetWIshForEdit = true;

      print("AddWishController - getWIshForEdit");
      final gotTheWish = await AddWishService.getWish(
        id,
        userService.currentUser!.id,
      );

      if (gotTheWish == null)
        throw SupabaseException(
          "Error",
          "Not found thw wish",
          KindOfException.notFound,
        );

      print("AddWishController - getWIshForEdit - title: ${gotTheWish.title}");
      // print("AddWishController - getWIshForEdit - title: ${gotTheWish.title}");

      wishForm.value = WishForm(
        id: gotTheWish.id,
        title: gotTheWish.title,
        description: gotTheWish.description,
        link: gotTheWish.link,
        imageUrl: gotTheWish.imageUrl,
        createdBy: gotTheWish.createdBy,
      );

      print(wishForm.toJson());

      // ? info: to set initial values
      titleController.text = wishForm.value.title ?? "";
      descriptionController.text = wishForm.value.description ?? "";
      linkController.text = wishForm.value.link ?? "";

      update();
    } on SupabaseException catch (e) {
      print("AddWishController - getWIshForEdit - SupabaseException - $e");

      var title = "Error";
      var message = "Error in Api.";

      if (e.kindOfException == KindOfException.notFound) {
        title = e.title;
        message = e.msg;
      }

      Get.snackbar(title, message);
      Get.offNamedUntil(NavigatorView.routeName, (route) => false);
    } catch (e) {
      print("AddWishController - addWish - Exception - ${e}");
      Get.snackbar("Exception", "Error get the wish.");
      Get.offNamedUntil(NavigatorView.routeName, (route) => false);
    } finally {
      // isGetWIshForEdit = false;
      // if done, change status to success
      // change(null, status: RxStatus.success());
      isWishLoading.value = false;
    }
  }

  Future<void> addWish() async {
    try {
      isLoading.value = true;
      if (!validateFields()) return;
      wishForm.value.createdBy = userService.user?.id;

      final addedWish = await AddWishService.addWish(wishForm.value);

      final homeController = Get.find<HomeController>();
      homeController.addWish(addedWish!);

      Get.back();
    } on SupabaseException catch (e) {
      print("AddWishController - addWish - SupabaseException - $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AddWishController - addWish - Exception - ${e}");
      Get.snackbar("Exception", "Error create wish");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveWish() async {
    try {
      isLoading.value = true;
      if (!validateFields()) return;
      wishForm.value.createdBy = userService.user?.id;

      final updatedWish = await AddWishService.updateWish(
        wishForm.value,
        userService.currentUser!.id,
      );

      final homeController = Get.find<HomeController>();
      homeController.updateWish(updatedWish!);

      // ? info: update if last screen was WishInfoView
      if (Get.previousRoute == WishInfoView.routeName) {
        final wishInfoController = Get.find<WishInfoController>();
        Get.back();
        wishInfoController.updateTheWish();
      }
    } on SupabaseException catch (e) {
      print("AddWishController - saveWish - SupabaseException - $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AddWishController - saveWish - Exception - ${e}");
      Get.snackbar("Exception", "Error updating wish.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final imagePicker = ImagePicker();

      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      if (pickedImage == null) return;

      wishForm.value.image = File(pickedImage.path);
      print(wishForm.value.image);
      wishForm.value.wasImageUpdate = true;

      wishForm.refresh();
      // update();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    }
  }
}
