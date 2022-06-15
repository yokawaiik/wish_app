import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/extensions/wish_color.dart';

import '../../../models/supabase_exception.dart';

import '../../navigator/views/navigator_view.dart';
import '../models/auth_user_form.dart';
import '../api_services/auth_api_service.dart';

class AuthController extends GetxController {
  RxBool isSignIn = RxBool(false);
  RxBool isLoading = RxBool(false);

  final authUserForm = AuthUserForm();

  late final GlobalKey<FormState> formKey;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    super.onInit();
  }

  void changeAuthMode() {
    isSignIn.value = !isSignIn.value;
  }

  bool validateFields() {
    return formKey.currentState!.validate();
  }

  Future<void> login() async {
    printInfo(info: "AuthController - login()");
    try {
      isLoading.value = true;

      if (!validateFields()) return;

      await AuthService.signIn(authUserForm);
      await Get.offAllNamed(NavigatorView.routeName);
    } on SupabaseException catch (e) {
      Get.snackbar("Error login", e.msg);
    } catch (e) {
      Get.snackbar("Error login", "It happened unknown error.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerNow() async {
    printInfo(info: "AuthController - registerNow()");
    try {
      isLoading.value = true;

      if (!validateFields()) return;

      authUserForm.userColor = WishColor.generateColor().toHex();
      await AuthService.signUp(authUserForm);

      await Get.offAllNamed(NavigatorView.routeName);
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
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
