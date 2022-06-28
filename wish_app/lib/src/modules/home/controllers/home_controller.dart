import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/home/api_services/home_api_service.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/wish/api_services/add_wish_api_service.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import '../../../services/user_service.dart';

class HomeController extends GetxController {
  final int nestedKey = 2;

  Future<bool> onWillPop() async {
    if (Get.nestedKey(nestedKey)!.currentState?.canPop() ?? true) {
      Get.nestedKey(nestedKey)!.currentState?.pop();
      return false;
    }
    return true;
  }
}
