import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/widgets/text_field_login.dart';

import '../controllers/auth_controller.dart';
import '../widgets/rounded_button.dart';

class AuthView extends GetView<AuthController> {
  static const routeName = "/auth";
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.secondaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => AnimatedSize(
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: controller.isSignIn.value
                        ? [
                            SizedBox(
                              height: 20,
                            ),
                            TextFieldLogin(
                              labelText: "Login",
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
              SizedBox(
                height: 20,
              ),
              TextFieldLogin(
                labelText: "Email",
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Get.theme.colorScheme.secondary,
                ),
                onChanged: (v) {
                  controller.authUserForm.email = v;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldLogin(
                labelText: "Password",
                isPassword: true,
                prefixIcon: Icon(
                  Icons.password,
                  color: Get.theme.colorScheme.secondary,
                ),
                onChanged: (v) {
                  controller.authUserForm.password = v;
                },
              ),
              SizedBox(
                height: 40,
              ),
              Obx(
                () => RoundedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.isSignIn.value
                          ? controller.registerNow()
                          : controller.login(),
                  text: controller.isSignIn.value ? "Register now" : 'Login',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () => controller.changeAuthMode(),
                child: Text(controller.isSignIn.value
                    ? "You already have an account?"
                    : 'Don\'t have an account?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
