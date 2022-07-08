import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/widgets/rounded_button.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';
import 'package:wish_app/src/modules/connection_manager/services/connection_manager_service.dart';

import '../../connection_manager/widgets/require_connection_widget.dart';
import "../utils/show_exit_app.dart" show showExitPopup;

class NavigatorView extends GetView<NavigatorController> {
  static const String routeName = "/";
  const NavigatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final cms = Get.find<ConnectionManagerService>();

        return RequireConnectionWidget(
          hasConnection: cms.connectionType.value != 0,
          primaryWidget: WillPopScope(
            onWillPop: controller.appOnWillPop,
            child: Scaffold(
              // for account screen other AppBar
              appBar: ![1, 2].toList().contains(controller.selectedIndex.value)
                  //  controller.selectedIndex.value != 2
                  ? AppBar(
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
                              // controller.userService.isAuthenticated
                              controller.isUserAuthenticated.value
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
                    )
                  : null,

              body: PageView(
                controller: controller.pageViewController,
                onPageChanged: (value) => controller.onItemTapped(value),
                children: controller.views,
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: controller.selectedIndex.value,
                onDestinationSelected: controller.onItemTapped,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.star),
                    label: "Favorites",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: "Account",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
