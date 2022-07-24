import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_app/src/modules/account/api_services/account_edit_api_service.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/models/account_edit_user.dart';

import '../../global/models/supabase_exception.dart';
import '../../global/services/user_service.dart';

class AccountEditController extends GetxController {
  late final UserService _us;
  late final AccountController _ac;

  late final Rx<AccountEditUser> accountEditUser;

  var isProfileImageUpdateLoad = RxBool(false);
  late final GlobalKey<FormState> formKeyInfo;
  var isInfoUpdateLoad = RxBool(false);
  late final GlobalKey<FormState> formKeyPassword;
  var isPasswordUpdateLoad = RxBool(false);

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordRepeatTextController = TextEditingController();

  @override
  void onInit() {
    _us = Get.find<UserService>();
    _ac = Get.find<AccountController>(tag: _us.currentUser!.id);
    formKeyInfo = GlobalKey<FormState>();
    formKeyPassword = GlobalKey<FormState>();

    setUser();

    super.onInit();
  }

  bool validateInfoFields() {
    if (accountEditUser.value.isLoginChanged == false) return false;

    return (formKeyInfo.currentState?.validate() ?? false);
  }

  bool validatePasswordFields() {
    return formKeyPassword.currentState?.validate() ?? false;
  }

  void setUser() {
    final currentUserMap = _us.currentUser!.toMap();

    currentUserMap.addAll({
      "imageUrl": _ac.userAccount.value!.imageUrl,
      "login": _ac.userAccount.value!.login,
    });

    accountEditUser =
        Rx<AccountEditUser>(AccountEditUser.fromMap(currentUserMap));

    loginTextController.text = accountEditUser.value.previousLogin;
    accountEditUser.refresh();
  }

  void editUserInfo() async {
    try {
      final user = accountEditUser.value;

      isInfoUpdateLoad.value = true;
      if (!validateInfoFields()) return;

      final isNewLoginExists = await AccountEditApiService.checkIfLoginExists(
        user.login!,
      );

      if (isNewLoginExists == false) {
        await AccountEditApiService.updateLogin(
          user.login!,
          user.id,
        );
        accountEditUser.value.previousLogin = user.login!;
        accountEditUser.refresh();

        // ? info: update account view
        _ac.updateUserAccountInfoByFields(login: user.login!);
        Get.focusScope?.unfocus();
      } else {
        Get.snackbar(
            "warning_title".tr, "account_aec_e_this_login_is_already_taken".tr);
      }
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
    } finally {
      isInfoUpdateLoad.value = false;
    }
  }

  void saveNewPassword() async {
    try {
      isPasswordUpdateLoad.value = true;
      if (!validatePasswordFields()) return;

      if (!accountEditUser.value.isPasswordsEqual) return;

      await AccountEditApiService.updatePassword(
          accountEditUser.value.password!);

      accountEditUser.value.password = '';
      accountEditUser.value.repeatPassword = '';

      passwordTextController.clear();
      passwordRepeatTextController.clear();

      accountEditUser.refresh();

      Get.focusScope?.unfocus();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
    } finally {
      isPasswordUpdateLoad.value = false;
    }
  }

  void changeProfilePhoto() async {
    try {
      isProfileImageUpdateLoad.value = true;
      final imagePicker = ImagePicker();

      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );
      if (pickedImage == null) return;

      final newRawProfileImageUrl =
          await AccountEditApiService.updateAccountImage(
        File(pickedImage.path),
        accountEditUser.value.id,
      );

      // ? info: clear cache loaded image if imageUrl is exists
      if (accountEditUser.value.imageUrl != null) {
        final provider = NetworkImage(accountEditUser.value.imageUrl!);
        await provider.evict();
        _ac.updateUserAccountInfoByFields(imageUrl: newRawProfileImageUrl);
      }

      accountEditUser.value.imageUrl = newRawProfileImageUrl;
      accountEditUser.refresh();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("error_title".tr, "error_unknown".tr);
    } finally {
      isProfileImageUpdateLoad.value = false;
    }
  }

  onChangedLogin(String value) {
    accountEditUser.value.login = value;
  }

  onChangedRetypePassword(String value) {
    accountEditUser.value.repeatPassword = value;

    passwordRepeatTextController.value = TextEditingValue(
      text: value,
      selection: TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      ),
    );
  }

  onChangedPassword(String value) {
    accountEditUser.value.password = value;

    passwordTextController.value = TextEditingValue(
      text: value,
      selection: TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      ),
    );
  }

  void onChangedformInfo() {
    accountEditUser.refresh();
    validateInfoFields();
  }

  void onChangedPasswordInfo() {
    accountEditUser.refresh();
    validatePasswordFields();
  }
}
