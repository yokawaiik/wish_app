import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  static const String routeName = "/account";
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("AccountView"),
              ),
            ],
          ),
        );
      },
    );
  }
}
