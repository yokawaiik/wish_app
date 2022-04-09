import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  static const String routeName = "/home";
  const HomeView({Key? key}) : super(key: key);

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
        child: Text("Home"),
      ),
    );
  }
}
