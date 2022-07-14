import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/global/theme/theme_wish_app.dart'
    as theme_wish_app;
import './modules/global/router/router.dart' as router;

import './modules/settings/utils/initial_settings_utils.dart'
    show setInitialLocale, setInitialTheme;

class WishApp extends StatelessWidget {
  const WishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: theme_wish_app.theme,
      darkTheme: theme_wish_app.darkTheme,
      themeMode: setInitialTheme(),
      getPages: router.getPages,
      initialRoute: router.initialRoute,
      unknownRoute: router.unknownRoute,
      locale: setInitialLocale(),
    );
  }
}
