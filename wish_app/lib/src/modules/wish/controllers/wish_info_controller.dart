import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/controllers/account_controller.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/favorites/views/favorites_view.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';

import '../../global/api_services/add_wish_api_service.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/models/unknown_exception.dart';
import '../../global/models/wish.dart';
import '../../global/services/user_service.dart';
import '../../global/utils/generate_wish_image_path.dart';
import '../../home/controllers/home_main_controller.dart';
import '../../home/views/home_view.dart';
import '../../navigator/views/navigator_view.dart';
import '../models/wish_info_arguments.dart';

import '../../home/constants/router_constants.dart' as router_constants;

class WishInfoController extends GetxController with StateMixin<Wish> {
  final hmc = Get.find<HomeMainController>();
  final _us = Get.find<UserService>();

  var currentWish = Rxn<Wish>();

  late final WishInfoArguments _args;
  bool _isInitialized = false;

  @override
  void onInit() async {
    getTheWish();
    super.onInit();
  }

  void setInfoArguments() {
    if (!_isInitialized) {
      final rawArgs = Get.arguments;
      // ? info: for web
      if (rawArgs == null) {
        // throw UnknownException("Error", "It isn't correct path...");
        throw UnknownException(
            "error_title".tr, "error_it_is_not_correct_path".tr);
      } else if (rawArgs is WishInfoArguments) {
        _args = rawArgs;
      } else {
        final id = rawArgs["id"] as int;
        final routeName = rawArgs["routeName"] as String?;
        _args = WishInfoArguments(wishId: id, previousRouteName: routeName);
      }
      _isInitialized = true;
    }
  }

  Future<void> getTheWish() async {
    try {
      change(currentWish.value, status: RxStatus.loading());

      setInfoArguments();

      switch (_args.previousRouteName) {
        case HomeView.routeName:
          final theFoundWish = hmc.getWishById(_args.wishId);
          currentWish.value = theFoundWish;

          break;
        case AccountView.routeName:
          final us = Get.find<UserService>();
          final tag = us.currentUser!.id;

          final ac = Get.find<AccountController>(tag: tag);
          final theFoundWish =
              ac.wishList.firstWhere((item) => item.id == _args.wishId);
          currentWish.value = theFoundWish;
          break;
        case router_constants.homeMainRouteName:
          final hmc = Get.find<HomeMainController>();
          final theFoundWish = hmc.getWishById(_args.wishId);
          currentWish.value = theFoundWish;
          break;

        case router_constants.homeAccountRouteName:
        case FavoritesView.routeName:
        default:
          final theFoundWish = await AddWishApiService.getWish(
            _args.wishId,
            _us.currentUser!.id,
          );
          currentWish.value = theFoundWish;
          break;
      }

      if (kDebugMode) {
        print('сurrentWish.value : ${currentWish.value}');
      }

      if (currentWish.value == null) {
        change(currentWish.value, status: RxStatus.error());
        throw SupabaseException(
          // "Error", "The wish was deleted.", KindOfException.notFound);
          "error_title".tr, "error_the_wish_was_delete".tr,
          KindOfException.notFound,
        );
      }

      change(currentWish.value, status: RxStatus.success());
    } on SupabaseException catch (e) {
      Get.back();
      Get.snackbar(e.title, e.msg);
    } on UnknownException catch (e) {
      Get.snackbar(e.title!, e.msg!);
    } catch (e) {
      if (kDebugMode) {
        print("WishInfoController - getTheWish - e: $e");
      }

      // Get.snackbar("Error", "Something went wrong.");
      Get.snackbar("error_title".tr, "error_something_went_wrong".tr);
      await Get.offNamedUntil(NavigatorView.routeName, (route) => false);

      // Get.back();
    }
  }

  void updateTheWish() async {
    await getTheWish();
    currentWish.refresh();
  }

  Future<void> editTheWish() async {
    await Get.toNamed(
      AddWishView.routeName,
      arguments: {
        "isEdit": true,
        ...currentWish.value!.toJson(),
      },
    );
  }

  deleteTheWish() async {
    try {
      String? imagePath;
      final theWish = currentWish.value!;

      if (theWish.hasImage) {
        imagePath = generateWishImagePath(
          theWish.imageUrl!,
          theWish.id.toString(),
        );
      }

      await AddWishApiService.deleteWish(theWish.id, imagePath);

      if (Get.isRegistered<HomeMainController>()) {
        Get.find<HomeMainController>().deleteWish(theWish.id);
      }

      if (Get.isRegistered<AccountController>(tag: theWish.createdBy.id)) {
        Get.find<AccountController>(tag: theWish.createdBy.id)
            .deleteWish(theWish.id);
      }

      if ([NavigatorView.routeName].contains(Get.previousRoute)) {
        Get.back();

        hmc.deleteWish(theWish.id);
      }
    } catch (e) {
      if (kDebugMode) {
        print("WishInfoController - deleteTheWish - e: $e");
      }

      Get.snackbar('error_title'.tr, "error_when_delete_the_wish".tr);
    }
  }

  // todo: addToFavorites
  void addToFavorites() {}

  // todo: shareTheWish
  void shareTheWish() {}

  // todo: seeProfile
  void seeProfile() {
    // if (Get.previousRoute == AccountView.routeName)
    //   Get.toNamed(
    //     AccountView.routeName,
    //     arguments: {
    //       "id": currentWish.value!.createdBy.id,
    //     },
    //   );
  }

  void updateWish(Wish wish) {
    currentWish.value = wish;
    currentWish.refresh();
  }
}
