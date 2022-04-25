import 'package:get/get.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';
import 'package:wish_app/src/modules/wish/service/add_wish_service.dart';

class AddWishController extends GetxController {
  final wishForm = WishForm();

  Future<void> addWish() async {
    try {
      await AddWishService.addWish(wishForm);

      Get.back();
      // todo: goto wish_view to show created wish 
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    }
  }

  Future<void> pickImage() async {}
}
