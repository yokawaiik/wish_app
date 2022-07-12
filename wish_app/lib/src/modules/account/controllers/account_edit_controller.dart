import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_app/src/modules/account/api_services/account_edit_api_service.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/models/account_edit_user.dart';

import 'package:wish_app/src/services/user_service.dart';

import '../../../models/supabase_exception.dart';
import '../../auth/api_services/auth_api_service.dart';

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
    return formKeyInfo.currentState?.validate() ?? false;
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
      } else {
        Get.snackbar("Warning", "This login is already taken.");
      }
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("Error", "Unknown error.");
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
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("Error", "Unknown error.");
    } finally {
      isPasswordUpdateLoad.value = false;
    }
  }

  // TODO: changeProfilePhoto
  // TODO: 1. generate imageName, 2. save image to bucket
  void changeProfilePhoto() async {
    try {
      isProfileImageUpdateLoad.value = true;
      final imagePicker = ImagePicker();

      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );
      if (pickedImage == null) return;

      final newProfileImageUrl = await AccountEditApiService.updateAccountImage(
        File(pickedImage.path),
        accountEditUser.value.id,
      );

      accountEditUser.value.imageUrl = newProfileImageUrl;

      accountEditUser.refresh();

      // todo: update AccountController
      // _ac.updateCurrentUser();
    } on SupabaseException catch (e) {
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      Get.snackbar("Error", "Unknown error.");
    } finally {
      isProfileImageUpdateLoad.value = false;
    }
  }

  onChangedLogin(String value) {
    accountEditUser.value.login = value;
  }

  onChangedRetypePassword(String value) {
    accountEditUser.value.repeatPassword = value;
    // passwordRepeatTextController.text = value;

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
