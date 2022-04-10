import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../../models/supabase_exception.dart';
import '../../../services/user_service.dart';
import '../../home/views/home_view.dart';
import '../../navigator/views/navigator_view.dart';
import '../models/auth_user_form.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  RxBool isSignIn = RxBool(false);
  RxBool isLoading = RxBool(false);

  final authUserForm = AuthUserForm();

  void changeAuthMode() {
    isSignIn.value = !isSignIn.value;
  }

  Future<void> login() async {
    printInfo(info: "AuthController - login()");
    try {
      isLoading.value = true;

      // Todo: validation

      await AuthService.signIn(authUserForm);
      await Get.offAllNamed(NavigatorView.routeName);
    } on SupabaseException catch (e) {
      Get.snackbar("Error login", e.msg);
    } 
    catch (e) {
      Get.snackbar("Error login", "It happened unknown error.");
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> registerNow() async {
    printInfo(info: "AuthController - registerNow()");
    try {
      isLoading.value = true;

      // Todo: validation

      await AuthService.signUp(authUserForm);

      await Get.offAllNamed(NavigatorView.routeName);
    } catch (e) {
      print(e);
      Get.snackbar("Error register now", "It happened unknown error.");
    } finally {
      isLoading.value = false;
    }
  }

  void goToNavigatorView() {
    Get.offAllNamed(NavigatorView.routeName);
  }
}
