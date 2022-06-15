import 'package:get/get.dart';
import 'package:wish_app/src/modules/account/views/account_view.dart';
import 'package:wish_app/src/modules/home/controllers/home_controller.dart';
import 'package:wish_app/src/modules/wish/api_services/add_wish_api_service.dart';
import 'package:wish_app/src/modules/wish/views/add_wish_view.dart';

import '../../../models/wish.dart';
import '../../home/views/home_view.dart';
import '../../navigator/views/navigator_view.dart';
import '../../../utils/generate_wish_image_path.dart';

class WishInfoController extends GetxController {
  final homeController = Get.find<HomeController>();

  // Wish? currentWish;

  var currentWish = Rxn<Wish?>();

  @override
  void onInit() {
    getTheWish();
    super.onInit();
  }

  Future<void> getTheWish() async {
    try {
      final id = Get.arguments["id"] as int;
      final routeName = Get.arguments["routeName"] as String?;

      switch (routeName) {
        case HomeView.routeName:
          final theFoundWish =
              homeController.homeWishList.firstWhere((item) => item.id == id);
          currentWish.value = theFoundWish;
          break;
        default:
          // todo: request to service if user came by link
          print('It\'s need to get from server');
      }

      if (currentWish == null) {
        Get.offNamed(HomeView.routeName);
        Get.snackbar("Ops...", "The wish was deleted.");
      }
    } catch (e) {
      print("WishInfoController - getTheWish - e: $e");
      Get.offNamedUntil(NavigatorView.routeName, (route) => false);
      Get.snackbar("Error", "Error when load the wish.");
    }
  }

  void updateTheWish() async {
    await getTheWish();
    currentWish.refresh();
  }

  Future<void> editTheWish() async {
    await Get.toNamed(AddWishView.routeName, arguments: {
      "isEdit": true,
      ...currentWish.value!.toJson(),
    });
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

      await AddWishService.deleteWish(theWish.id, imagePath);

      if ([NavigatorView.routeName].contains(Get.previousRoute)) {
        Get.back();
        homeController.deleteWish(theWish.id);
      }
    } catch (e) {
      print("WishInfoController - deleteTheWish - e: $e");
      // Get.offNamedUntil(NavigatorView.routeName, (route) => false);
      Get.snackbar("Error", "Error when delete the wish. Try later.");
    }
  }

  // todo: addToFavorites
  void addToFavorites() {}

  // todo: shareTheWish
  void shareTheWish() {}

  // todo: seeProfile
  void seeProfile() {
    Get.toNamed(
      AccountView.routeName,
      arguments: {
        "id": currentWish.value!.createdBy.id,
      },
    );
  }
}
