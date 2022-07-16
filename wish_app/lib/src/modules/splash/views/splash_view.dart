import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/splash/bindings/splash_binding.dart';

class SplashView extends GetView<SplashBindings> {
  static const routeName = "/splash";
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("s_sv_text_on_screen".tr),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
