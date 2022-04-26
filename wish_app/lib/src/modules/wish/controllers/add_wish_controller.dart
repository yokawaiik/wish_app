import 'dart:io';

import 'package:get/get.dart';

import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';
import 'package:wish_app/src/modules/wish/service/add_wish_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wish_app/src/services/user_service.dart';

class AddWishController extends GetxController {
  final wishForm = WishForm();

  final userService = Get.find<UserService>();

  Future<void> addWish() async {
    try {
      wishForm.createdBy = userService.user?.id;

      await AddWishService.addWish(wishForm);

      Get.back();
      // todo: goto wish_view to show created wish
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
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

      wishForm.image = File(pickedImage.path);
      print(wishForm.image);
      update();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    }
  }
}
