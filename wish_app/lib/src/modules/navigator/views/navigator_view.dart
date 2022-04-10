import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';

class NavigatorView extends GetView<NavigatorController> {
  static const String routeName = "/navigator";
  const NavigatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("Sign Out"),
                onTap: () => controller.signOut(),
              )
            ],
          ),
        ],
      ),
      body: Center(
        
      ),
    );
  }
}
