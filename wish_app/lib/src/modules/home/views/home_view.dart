import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/bindings/account_bindings.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/home/bindings/home_main_binding.dart';
import 'package:wish_app/src/modules/home/views/home_main_view.dart';

import '../../account/models/account_arguments.dart';
import '../controllers/home_controller.dart';

import '../constants/router_constants.dart' as router_constants;

class HomeView extends GetView<HomeController> {
  static const String routeName = "/home";

  HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Navigator(
        // todo: test it
        observers: [GetObserver((_) {}, Get.routing)],
        // body: GetNavigator(
        key: Get.nestedKey(controller.nestedKey),
        // initialRoute: HomeMainView.routeName,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case router_constants.homeAccountRouteName:
              var args = settings.arguments as AccountArguments;

              return GetPageRoute(
                routeName: router_constants.homeAccountRouteName,
                settings: settings,
                page: () => AccountView(tag: args.tag),
                binding: AccountBindings(tag: args.tag, isAnotherUser: true),
              );
            default:
              return GetPageRoute(
                routeName: router_constants.homeMainRouteName,
                settings: settings,
                page: () => HomeMainView(),
                binding: HomeMainBindings(),
              );
          }
        },
      ),
    );
  }
}

// class AccountTestPage extends StatelessWidget {
//   static const routeName = '/home/account';

//   final homeController = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [],
//         ),
//       ),
//     );
//   }
// }

// class AccountTestController extends GetxController {
//   final title = 'AccountTest'.obs;
// }

// class AccountTestBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => AccountTestController());
//   }
// }
