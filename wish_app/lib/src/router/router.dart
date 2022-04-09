import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/bindings/auth_binding.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/bindings/home_binding.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/splash/bindings/splash_binding.dart';
import 'package:wish_app/src/modules/splash/views/splash_view.dart';

final List<GetPage> getPages = [
  GetPage(
    name: SplashView.routeName,
    page: () => const SplashView(),
    transition: Transition.upToDown,
    binding: SplashBinding(),
  ),
  GetPage(
    name: AuthView.routeName,
    page: () => const AuthView(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: HomeView.routeName,
    page: () => const HomeView(),
    binding: HomeBindings(),
  )
];

final initialRoute = SplashView.routeName;
