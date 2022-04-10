import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/current_user.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/auth/models/auth_user_form.dart';
import 'package:wish_app/src/modules/auth/services/auth_service.dart';
import 'package:wish_app/src/services/user_service.dart';

import '../../home/views/home_view.dart';

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
      await Get.offAndToNamed(HomeView.routeName);
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

      print(
          "currentUser?.email - ${Get.find<UserService>().currentUser?.email}");
      // Get.offAndToNamed(HomeView.routeName)
      await Get.offAndToNamed(HomeView.routeName);
    } catch (e) {
      print(e);
      Get.snackbar("Error register now", "It happened unknown error.");
    } finally {
      isLoading.value = false;
    }
  }
}
