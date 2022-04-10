import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/widgets/rounded_button.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';

class NavigatorView extends GetView<NavigatorController> {
  static const String routeName = "/";
  const NavigatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // print(controller.userService.isAuthenticated.value);
              // return [
              //   controller.userService.isAuthenticated.isTrue
              //       ? PopupMenuItem(
              //           child: Text("Sign Out"),
              //           onTap: () => controller.signOut(),
              //         )
              //       : PopupMenuItem(
              //           child: Text("Sign In"),
              //           onTap: () => controller.goToAuthView(),
              //         ),
              // ];
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
