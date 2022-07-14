import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/modules/wish/controllers/wish_info_controller.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';

import '../../account/views/account_view.dart';
import '../../global/api_services/add_wish_api_service.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/services/user_service.dart';
import '../../home/controllers/home_main_controller.dart';
import '../../home/views/home_view.dart';

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
        final isCurrentUser =
            Get.arguments["createdBy"]["isCurrentUser"] as bool;

        if (!isCurrentUser) {
          // Get.offAndToNamed(HomeView.routeName);
          Get.offNamedUntil(NavigatorView.routeName, (route) => false);
          // Get.snackbar("Error", "You are not a creator");
          Get.snackbar("error_title".tr, "wa_e_not_a_creator".tr);
        }

        if (id == null) {
          // Get.offAndToNamed(NavigatorView.routeName);
          Get.offNamedUntil(NavigatorView.routeName, (route) => false);
          // Get.snackbar("Error",
          //     "You want to edit wish but wish with this id doesn't exist or was deleted.");
          Get.snackbar(
              "error_title".tr, "wa_e_wish_does_not_exist_or_was_delete".tr);
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
      isWishLoading.value = true;
      final gotTheWish = await AddWishApiService.getWish(
        id,
        userService.currentUser!.id,
      );

      if (gotTheWish == null)
        throw SupabaseException(
          // "Error",
          // "Not found the wish",
          "error_title".tr,
          // "Not found the wish",
          "wa_es_wish_not_found".tr,
          KindOfException.notFound,
        );

      wishForm.value = WishForm(
        id: gotTheWish.id,
        title: gotTheWish.title,
        description: gotTheWish.description,
        link: gotTheWish.link,
        imageUrl: gotTheWish.imageUrl,
        createdBy: gotTheWish.createdBy.id,
      );

      // print(wishForm.toJson());

      // ? info: to set initial values
      titleController.text = wishForm.value.title ?? "";
      descriptionController.text = wishForm.value.description ?? "";
      linkController.text = wishForm.value.link ?? "";

      update();
    } on SupabaseException catch (e) {
      print("AddWishController - getWIshForEdit - SupabaseException - $e");

      // var title = "Error";
      var title = "error_title".tr;
      var message = "error_in_api".tr;

      if (e.kindOfException == KindOfException.notFound) {
        title = e.title;
        message = e.msg;
      }

      Get.snackbar(title, message);
      Get.offNamedUntil(NavigatorView.routeName, (route) => false);
    } catch (e) {
      print("AddWishController - getWIshForEdit - Exception - ${e}");
      // Get.snackbar("Exception", "Error get the wish.");
      Get.snackbar(
        "error_title".tr,
        "wa_e_getting_wish".tr,
      );
      Get.offNamedUntil(NavigatorView.routeName, (route) => false);
    } finally {
      isWishLoading.value = false;
    }
  }

  Future<void> addWish() async {
    try {
      isLoading.value = true;
      if (!validateFields()) return;
      // wishForm.value.createdBy = userService.user?.id;
      wishForm.value.createdBy = userService.currentUser?.id;

      final addedWish = await AddWishApiService.addWish(wishForm.value);

      // if user came here from home
      // or account

      final routes = Get.routeTree.routes.map((e) => e.name).toList();

      if (routes.contains(AccountView.routeName)) {
        final tag = userService.currentUser!.id;
        final accountController = Get.find<AccountController>(tag: tag);
        accountController.addWish(addedWish!);
      }

      if (routes.contains(HomeView.routeName)) {
        final homeController = Get.find<HomeMainController>();
        homeController.addWish(addedWish!);
      }

      Get.back();
    } on SupabaseException catch (e) {
      print("AddWishController - addWish - SupabaseException - $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AddWishController - addWish - Exception - ${e}");
      // Get.snackbar("Exception", "Error create wish");
      Get.snackbar(
        "error_title".tr,
        "wa_e_creating_wish".tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveWish() async {
    try {
      isLoading.value = true;
      if (!validateFields()) return;
      wishForm.value.createdBy = userService.currentUser?.id;

      final updatedWish = await AddWishApiService.updateWish(
        wishForm.value,
        userService.currentUser!.id,
      );

      if (Get.isRegistered<AccountController>()) {
        final tag = userService.currentUser!.id;
        final ac = Get.find<AccountController>(tag: tag);
        ac.updateTheWish(updatedWish!);
      }
      if (Get.isRegistered<HomeMainController>()) {
        final hc = Get.find<HomeMainController>();
        hc.updateWish(updatedWish!);
      }

      // ? info: update if last screen was WishInfoView
      if (Get.previousRoute == WishInfoView.routeName) {
        final wic = Get.find<WishInfoController>();
        wic.updateWish(updatedWish!);
        Get.back();
      }
    } on SupabaseException catch (e) {
      print("AddWishController - saveWish - SupabaseException - $e");
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AddWishController - saveWish - Exception - ${e}");
      // Get.snackbar("Exception", "Error updating wish.");
      Get.snackbar(
        "error_title".tr,
        "wa_e_updating_wish".tr,
      );
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
      wishForm.value.wasImageUpdate = true;

      wishForm.refresh();

      if (isEdit.value) {
        wishForm.value.wasImageUpdate = true;
      }
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    }
  }
}
