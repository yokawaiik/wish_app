import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/api_services/user_api_service.dart';
import 'package:wish_app/src/models/current_user.dart';
import 'package:wish_app/src/models/user_account.dart';

class UserService extends GetxService {
  final _supabase = Supabase.instance;

  UserAccount? _currentUserDetail;

  Future<UserService> init() async => this;

  // Future<CurrentUser?> get currentUser {
  CurrentUser? get currentUser {
    // Rx<CurrentUser>? get currentUser {
    // todo: remove currentUser || return currentUser as null
    _supabase.client.auth.onAuthStateChange((event, session) {
      // print("currentUser - onAuthStateChange $event");
      // if (event == AuthChangeEvent.signedOut) {
      //   return null;
      // }
      print(
          "UserService - get - currentUser - _supabase.client.auth.onAuthStateChange");
      print(event);
      print(session);
    });

    final authUser = _supabase.client.auth.currentUser;

    if (authUser == null) {
      return null;
    } else {
      // final user = (await _supabase.client
      //         .from("users")
      //         .select("*")
      //         .eq("id", authUser.id)
      //         .single()
      //         .execute())
      //     .data;

      final currentUser = CurrentUser(
        id: authUser.id,
        appMetadata: authUser.appMetadata,
        userMetadata: authUser.userMetadata,
        aud: authUser.aud,
        email: authUser.email,
        phone: authUser.phone,
        createdAt: authUser.createdAt,
        // login: user["login"],
      );
      return currentUser;
    }
  }

  Rx<bool> get isUserAuthenticated {
    // print("isUserAuthenticated - ${currentUser == null ? false : true}");
    return RxBool(currentUser == null ? false : true);
  }

  // Future<UserAccount?> get getCurrentUserDetail async {
  //   try {
  //     if (isUserAuthenticated.value) {
  //       if (_currentUserDetail == null) {
  //         final gotTheUser = await UserApiService.getUser(
  //           currentUser!.id,
  //           currentUser!.id,
  //         );

  //         final gotUserInfo = await UserApiService.getUserInfo(currentUser!.id);

  //         gotTheUser!.setUserInfoFromMap(gotUserInfo!);

  //         _currentUserDetail = gotTheUser;
  //         return _currentUserDetail;
  //       } else {
  //         return _currentUserDetail;
  //       }
  //     }

  //     return null;
  //   } catch (e) {
  //     print("UserService - getCurrentUserDetail - e: $e");
  //     return null;
  //   }
  // }

  Future<void> signOut() async {
    UserApiService.signOut();
  }

  // CurrentUser? get user {
  //   final authUser = _supabase.client.auth.currentUser;
  //   if (authUser == null) {
  //     return null;
  //   } else {
  //     final currentUser = CurrentUser(
  //       id: authUser.id,
  //       appMetadata: authUser.appMetadata,
  //       userMetadata: authUser.userMetadata,
  //       aud: authUser.aud,
  //       email: authUser.email,
  //       phone: authUser.phone,
  //       createdAt: authUser.createdAt,
  //     );
  //     return currentUser;
  //   }
  // }

  // bool get isAuthenticated {
  //   // print("isAuthenticated - ${user == null ? false : true}");
  //   return user == null ? false : true;
  // }
}
