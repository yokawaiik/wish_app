import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';

import '../../global/extensions/wish_color.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/services/user_service.dart';
import '../../home/controllers/home_main_controller.dart';
import '../models/auth_user_form.dart';
import '../api_services/auth_api_service.dart';

class AuthController extends GetxController {
  RxBool isSignIn = RxBool(false);
  RxBool isLoading = RxBool(false);

  final authUserForm = AuthUserForm();

  late final GlobalKey<FormState> formKey;

  final _navigatorController = Get.find<NavigatorController>();
  final _userService = Get.find<UserService>();

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

      await AuthApiService.signIn(authUserForm);
      Get.back();

      _userService.signIn();

      _updateApp();
    } on SupabaseException catch (e) {
      Get.snackbar("auth_ac_es_error_login".tr, e.msg);
    } catch (e) {
      // Get.snackbar("Error login", "It happened unknown error.");
      Get.snackbar("error_title".tr, "error_unknown".tr);
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
      await AuthApiService.signUp(authUserForm);

      Get.back();
      _userService.signUp();

      _updateApp();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print(e);
      Get.snackbar("error_title".tr, "error_unknown".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateApp() async {
    _navigatorController.updateAccountView();
    final hmc = Get.find<HomeMainController>();
    await hmc.refreshWishList();
  }

  void goToNavigatorView() {
    Get.back();
  }
}
