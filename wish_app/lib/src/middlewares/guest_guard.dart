import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';

import '../modules/navigator/views/navigator_view.dart';
import '../services/user_service.dart';

class GuestGuard extends GetMiddleware {
  final authService = Get.find<UserService>();

  @override
  RouteSettings? redirect(String? route) {
    return authService.isUserAuthenticated!
        ? null
        : const RouteSettings(name: NavigatorView.routeName);
  }
}
