import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/widgets/default_text_field.dart';
import '../../global/widgets/password_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/rounded_button.dart';

import '../../global/utils/auth_validators.dart' as auth_validators;

class AuthView extends GetView<AuthController> {
  static const routeName = "/auth";
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: controller.goToNavigatorView,
            icon: Icon(
              Icons.dashboard,
              color: Get.theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'auth_av_form_title'.tr,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      children: controller.isSignIn.value
                          ? [
                              const SizedBox(
                                height: 20,
                              ),
                              DefaultTextField(
                                labelText: "auth_av_dtf_label_login".tr,
                                autofillHints: const [AutofillHints.nickname],
                                validator: auth_validators.checkLogin,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Get.theme.colorScheme.secondary,
                                ),
                                onChanged: (v) {
                                  controller.authUserForm.login = v;
                                },
                              ),
                            ]
                          : [],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  labelText: "auth_av_dtf_label_email".tr,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  validator: auth_validators.checkEmail,
                  onChanged: (v) {
                    controller.authUserForm.email = v;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PasswordTextField(
                  labelText: "auth_av_ptf_label_password".tr,
                  validator: auth_validators.checkPassword,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: Icon(
                    Icons.password,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  onChanged: (v) {
                    controller.authUserForm.password = v;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Obx(
                  () => _buildRoundedButton(),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () => controller.changeAuthMode(),
                  child: Text(controller.isSignIn.value
                      ? "auth_av_tb_text_is_sign_in_true".tr
                      : 'auth_av_tb_text_is_sign_in_false'.tr),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  RoundedButton _buildRoundedButton() {
    return RoundedButton(
      onPressed: controller.isLoading.value
          ? null
          : () => controller.isSignIn.value
              ? controller.registerNow()
              : controller.login(),
      child: controller.isLoading.value
          ? SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Get.theme.colorScheme.secondary,
              ),
            )
          : Text(
              (controller.isSignIn.value
                      ? "auth_av_rb_text_is_sign_in_true".tr
                      : 'auth_av_rb_text_is_sign_in_false'.tr)
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
    );
  }
}
