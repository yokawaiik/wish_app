import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/widgets/rounded_button.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';

class NavigatorView extends GetView<NavigatorController> {
  static const String routeName = "/";
  const NavigatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.menu),
              onSelected: (int v) {
                switch (v) {
                  case 0:
                    controller.signOut();
                    break;
                  case 1:
                    controller.goToAuthView();
                    break;
                  default:
                }
              },
              itemBuilder: (ctx) {
                return [
                  controller.userService.isAuthenticated
                      ? PopupMenuItem(
                          child: Text("Sign Out"),
                          value: 0,
                        )
                      : PopupMenuItem(
                          child: Text("Sign In"),
                          value: 1,
                        ),
                ];
              },
            ),
          ],
        ),
        body: controller.currentView,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
