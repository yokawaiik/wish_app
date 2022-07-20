import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_edit_controller.dart';
import 'package:wish_app/src/modules/global/extensions/wish_color.dart';

import '../../global/constants/global_constants.dart' as global_constants;
import '../../global/utils/auth_validators.dart' as auth_validators;
import '../../global/widgets/account_user_avatar.dart';
import '../../global/widgets/default_text_field.dart';
import '../../global/widgets/password_text_field.dart';
import '../../global/widgets/skeleton.dart';
import '../utils/account_edit_validators.dart' as account_edit_validators;

class AccountEditView extends GetView<AccountEditController> {
  static const routeName = '/account/edit';
  const AccountEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Get.textTheme;

    return Scaffold(
      appBar: AppBar(
        // title: const Text("Edit account info"),
        title: Text("account_edit_view_appbar_title".tr),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () {
            final accountEditUser = controller.accountEditUser.value;

            final isInfoUpdateLoad = controller.isInfoUpdateLoad.value;
            final isPasswordUpdateLoad = controller.isPasswordUpdateLoad.value;
            final isProfileImageUpdateLoad =
                controller.isProfileImageUpdateLoad.value;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    global_constants.defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          _imageProfileBuild(),
                          const SizedBox(
                            height: global_constants.defaultIndentFields,
                          ),
                          TextButton(
                            onPressed: isProfileImageUpdateLoad
                                ? null
                                : controller.changeProfilePhoto,
                            // child: Text("Change profile photo"),
                            child: Text("account_edit_view_text_button".tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: global_constants.defaultPadding,
                  ),
                  child: Form(
                    onChanged: controller.onChangedformInfo,
                    key: controller.formKeyInfo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: global_constants.defaultIndentFields,
                        ),
                        DefaultTextField(
                          controller: controller.loginTextController,
                          labelText:
                              "account_edit_view_default_text_field_label".tr,
                          validator: auth_validators.checkLogin,
                          onChanged: controller.onChangedLogin,
                        ),
                        const SizedBox(
                          height: global_constants.defaultIndentFields,
                        ),

                        ElevatedButton(
                          onPressed:
                              (controller.validateInfoFields() == false ||
                                      isInfoUpdateLoad == true)
                                  ? null
                                  : controller.editUserInfo,
                          child: isInfoUpdateLoad
                              ? const SizedBox(
                                  height: global_constants
                                      .progressIndicatorHeightInButton,
                                  width: global_constants
                                      .progressIndicatorHeightInButton,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  "account_edit_view_elevated_button_text_set_new_info"
                                      .tr,
                                  style: TextStyle(
                                    fontSize: textTheme.bodyText1!.fontSize,
                                  ),
                                ),
                        ),
                        // ],
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: global_constants.defaultIndentFields,
                ),
                const Divider(),
                const SizedBox(
                  height: global_constants.defaultIndentFields,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: global_constants.defaultPadding,
                  ),
                  child: Form(
                    key: controller.formKeyPassword,
                    onChanged: controller.onChangedPasswordInfo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PasswordTextField(
                          labelText:
                              "account_edit_view_password_text_field_label_new_password"
                                  .tr,
                          controller: controller.passwordTextController,
                          validator: account_edit_validators.checkPassword,
                          onChanged: controller.onChangedPassword,
                        ),
                        const SizedBox(
                          height: global_constants.defaultIndentFields,
                        ),
                        PasswordTextField(
                          labelText:
                              "account_edit_view_password_text_field_label_retype_new_password"
                                  .tr,
                          controller: controller.passwordRepeatTextController,
                          validator: (value) =>
                              account_edit_validators.checkPassword(
                            value,
                            fieldName:
                                "account_edit_view_password_text_field_label_retype_new_password"
                                    .tr,
                            isRetypePassword: true,
                            originalField: accountEditUser.password,
                          ),
                          onChanged: controller.onChangedRetypePassword,
                        ),
                        const SizedBox(
                          height: global_constants.defaultIndentFields,
                        ),
                        ElevatedButton(
                          onPressed: (isPasswordUpdateLoad ||
                                  !accountEditUser.isPasswordsEqual ||
                                  !controller.validatePasswordFields())
                              ? null
                              : controller.saveNewPassword,
                          child: isPasswordUpdateLoad
                              ? const SizedBox(
                                  height: global_constants
                                      .progressIndicatorHeightInButton,
                                  width: global_constants
                                      .progressIndicatorHeightInButton,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  // "Set new password",
                                  "account_edit_view_elevated_button_text_set_new_password"
                                      .tr,
                                  style: TextStyle(
                                      fontSize: textTheme.bodyText1!.fontSize),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: global_constants.defaultIndentFields,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _imageProfileBuild() {
    final colorScheme = Get.theme.colorScheme;
    final accountEditUser = controller.accountEditUser.value;

    final isProfileImageUpdateLoad = controller.isProfileImageUpdateLoad.value;

    return GestureDetector(
      onTap: isProfileImageUpdateLoad ? null : controller.changeProfilePhoto,
      child: (accountEditUser.hasImage && !isProfileImageUpdateLoad)
          ? AccountUserAvatar(
              key: ValueKey(
                  accountEditUser.imageUrl), // ? info: to update widget image
              defaultColor: colorScheme.primary,
              userColor: accountEditUser.userColor == null
                  ? null
                  : WishColor.fromHex(accountEditUser.userColor!),
              imageUrl: accountEditUser.imageUrl,
              radius: 50,
            )
          : Skeleton.round(radius: 50),
    );
  }
}
