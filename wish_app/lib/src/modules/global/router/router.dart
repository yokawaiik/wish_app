import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/views/account_edit_view.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/auth/bindings/auth_bindings.dart';
import 'package:wish_app/src/modules/auth/views/auth_view.dart';
import 'package:wish_app/src/modules/home/bindings/home_binding.dart';
import 'package:wish_app/src/modules/home/views/home_view.dart';
import 'package:wish_app/src/modules/navigator/bindings/navigator_binding.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';
import 'package:wish_app/src/modules/settings/views/setting_view.dart';
import 'package:wish_app/src/modules/splash/bindings/splash_binding.dart';
import 'package:wish_app/src/modules/splash/views/splash_view.dart';
import 'package:wish_app/src/modules/wish/bindings/add_wish_bindings.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';
import 'package:wish_app/src/modules/wish/views/wish_info_view.dart';
import '../../account/bindings/account_bindings.dart';
import '../../account/bindings/account_edit_bindings.dart';
import '../../settings/bindings/settings_bindings.dart';
import '../../unknown/bindings/unknown_bindings.dart';
import '../../unknown/views/unknown_view.dart';
import '../../wish/bindings/wish_info_bindings.dart';
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
    name: AccountView.routeName,
    page: () => AccountView(),
    binding: AccountBindings(),
  ),
  GetPage(
    name: AccountEditView.routeName,
    page: () => const AccountEditView(),
    binding: AccountEditBindings(),
  ),
  GetPage(
    name: AddWishView.routeName,
    page: () => AddWishView(),
    binding: AddWishBindings(),
  ),
  GetPage(
    name: WishInfoView.routeName,
    page: () => const WishInfoView(),
    binding: WishInfoBindings(),
  ),
  GetPage(
    name: SettingView.routeName,
    page: () => const SettingView(),
    binding: SettingsBindings(),
  ),
];

final unknownRoute = GetPage(
  name: UnknownView.routeName,
  page: () => const UnknownView(),
  binding: UnknownBindings(),
);

const initialRoute = NavigatorView.routeName;
