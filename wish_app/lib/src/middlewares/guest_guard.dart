import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';

import '../services/user_service.dart';

class GuestGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<UserService>();
    // print("GuestGuard - $route");
    // print("authService.isAuthenticated - ${authService.isAuthenticated}");

    return !authService.isAuthenticated
        ? null
        : RouteSettings(name: NavigatorView.routeName);
  }



}
