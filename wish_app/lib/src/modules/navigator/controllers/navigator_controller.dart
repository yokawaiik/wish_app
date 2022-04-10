import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/views/auth_view.dart';
import '../services/navigator_service.dart';

class NavigatorController extends GetxController {
  static final _supabase = Supabase.instance;

  Future<void> signOut() async {
    printInfo(info: 'HomeController - signOut()');
    await NavigatorService.signOut();
    await Get.offAllNamed(AuthView.routeName);
  }
}
