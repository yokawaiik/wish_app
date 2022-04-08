import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/theme/theme_wish_app.dart' as themeWishApp;
import './router/router.dart' as router;

class WishApp extends StatelessWidget {
  const WishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: themeWishApp.theme,
      darkTheme: themeWishApp.darkTheme,
      getPages: router.getPages,
    );
  }
}
