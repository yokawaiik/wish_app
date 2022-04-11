import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/bindings/global_bindings.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/theme/theme_wish_app.dart' as theme_wish_app;
import './router/router.dart' as router;

class WishApp extends StatelessWidget {
  const WishApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: theme_wish_app.theme,
      darkTheme: theme_wish_app.darkTheme,
      getPages: router.getPages,
      // home: NavigatorView(),
      initialRoute: router.initialRoute,
      // initialBinding: GlobalBindings(),
    );
  }
}