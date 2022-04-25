import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import '../../../services/user_service.dart';

class HomeController extends GetxController {
  final _supabase = Supabase.instance;
  final userService = Get.find<UserService>();

  Rx<bool> get isUserAuthenticated => userService.isUserAuthenticated;

  Future<void> addNewWish() async {
    await Get.toNamed(AddWishView.routeName);
  }
}
