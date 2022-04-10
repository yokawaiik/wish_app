import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../auth/views/auth_view.dart';
import '../services/navigator_service.dart';

class NavigatorController extends GetxController {
  final _supabase = Supabase.instance;

  final userService = Get.find<UserService>();

  Rx<bool> get isUserAuthenticated => userService.isUserAuthenticated;

  Future<void> signOut() async {
    printInfo(info: 'NavigatorController - signOut()');
    await NavigatorService.signOut();
  }

  Future<void> goToAuthView() async {
    Get.back();
    await Get.toNamed(AuthView.routeName);
    // Get.toNamed(AuthView.routeName, preventDuplicates: false);
  }
}
