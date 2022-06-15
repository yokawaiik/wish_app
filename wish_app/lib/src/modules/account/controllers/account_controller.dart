import 'package:get/get.dart';
import 'package:wish_app/src/api_services/api_user_service.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/user_account.dart';
import 'package:wish_app/src/services/user_service.dart';

import "../../../utils/router_utils.dart" as router_utils;

class AccountController extends GetxController {
  final _userService = Get.find<UserService>();

  var userAccount = Rxn<UserAccount>();

  var isLoading = Rx<bool>(false);

  bool get isCurrentUser => userAccount.value?.isCurrentUser ?? false;

  @override
  void onInit() async {
    await getUser();
    super.onInit();
    // print("AccountController - onInit - userAccount : $userAccount");
  }

  Future<void> getUser() async {
    print("AccountController - getUser()");
    isLoading.value = true;
    try {
      // an unknown user visits someone's account
      if (Get.arguments != null && Get.arguments["id"] != null) {
        final gotTheUser = await ApiUserService.getUser(
          Get.arguments["id"],
          null,
        );
        print("gotTheUser : ${gotTheUser?.id}");
        if (gotTheUser == null) {
          throw SupabaseException("Error", "Such an user didn't find.");
        }

        userAccount.value = gotTheUser;
        // my account
      } else if (_userService.isUserAuthenticated.value) {
        final gotTheUser = (await _userService.getCurrentUserDetail);
        print("AccountController - getUser() - gotTheUser : $gotTheUser");

        if (gotTheUser == null) {
          throw SupabaseException(
              "Error", "Something went wrong when get user details...");
        }

        userAccount.value = gotTheUser;
      } else {
        throw SupabaseException("Error", "It isn't an user.");
      }
    } on SupabaseException catch (e) {
      print("AccountController - getUser - SupabaseException - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar(e.title, e.msg);
    } catch (e) {
      print("AccountController - getUser - e: $e");
      await router_utils.toBackOrMainPage();
      Get.snackbar("Error", "Unknown error...");
    } finally {
      isLoading.value = false;
    }
  }

  // todo: createWish
  void createWish() {}

  // todo: exit
  void exit() {}

  // todo: goToLoginPage
  void goToLoginPage() {}
}
