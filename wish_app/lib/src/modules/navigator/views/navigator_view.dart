import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_app/src/modules/navigator/controllers/navigator_controller.dart';
import 'package:wish_app/src/modules/connection_manager/services/connection_manager_service.dart';

import '../../connection_manager/widgets/require_connection_widget.dart';

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
              // ? info: for account screen other AppBar
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
                                      // child: Text("Sign Out"),
                                      child: Text("nm_nv_pmb_pmi_sign_out".tr),
                                      value: 0,
                                    )
                                  : PopupMenuItem(
                                      // child: Text("Sign In"),
                                      child: Text("nm_nv_pmb_pmi_sign_in".tr),
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
                    icon: const Icon(Icons.star),
                    label: "nm_nv_nb_nd_favorites".tr,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.home),
                    label: "nm_nv_nb_nd_home".tr,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person),
                    label: "nm_nv_nb_nd_account".tr,
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
