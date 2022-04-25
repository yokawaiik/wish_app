import 'package:get/get.dart';
import 'package:wish_app/src/modules/auth/bindings/auth_bindings.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/bindings/home_binding.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/navigator/bindings/navigator_binding.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/modules/splash/bindings/splash_binding.dart';
import 'package:wish_app/src/modules/splash/views/splash_view.dart';
import 'package:wish_app/src/modules/wish/bindings/add_wish_binding.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';

import '../middlewares/guest_guard.dart';

final List<GetPage> getPages = [
  GetPage(
    name: AuthView.routeName,
    page: () => const AuthView(),
    binding: AuthBindings(),
    middlewares: [
      GuestGuard(),
    ],
  ),
  GetPage(
    name: SplashView.routeName,
    page: () => const SplashView(),
    transition: Transition.upToDown,
    binding: SplashBindings(),
  ),
  GetPage(
    name: NavigatorView.routeName,
    page: () => const NavigatorView(),
    binding: NavigatorBindings(),
  ),
  GetPage(
    name: HomeView.routeName,
    page: () => const HomeView(),
    binding: HomeBindings(),
  ),
  GetPage(
    name: AddWishView.routeName,
    page: () => AddWishView(),
    binding: AddWishBinding(),
  ),
];

final initialRoute = NavigatorView.routeName;
