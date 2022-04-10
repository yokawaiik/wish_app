import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';

import '../services/user_service.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<UserService>();
    print("AuthGuard");
    return authService.isUserAuthenticated.value
        ? null
        : const RouteSettings(name: AuthView.routeName);
  }
}
