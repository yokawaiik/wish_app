import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/current_user.dart';

class UserService extends GetxService {
  final _supabase = Supabase.instance;

  Future<UserService> init() async => this;


   

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
      final currentUser = CurrentUser(
        id: authUser.id,
        appMetadata: authUser.appMetadata,
        userMetadata: authUser.userMetadata,
        aud: authUser.aud,
        email: authUser.email,
        phone: authUser.phone,
        createdAt: authUser.createdAt,
      );
      return currentUser;
    }
  }

  Rx<bool> get isUserAuthenticated {
    // print("isUserAuthenticated - ${currentUser == null ? false : true}");
    return RxBool(currentUser == null ? false : true);
  }

  CurrentUser? get user {
    final authUser = _supabase.client.auth.currentUser;
    if (authUser == null) {
      return null;
    } else {
      final currentUser = CurrentUser(
        id: authUser.id,
        appMetadata: authUser.appMetadata,
        userMetadata: authUser.userMetadata,
        aud: authUser.aud,
        email: authUser.email,
        phone: authUser.phone,
        createdAt: authUser.createdAt,
      );
      return currentUser;
    }
  }

  bool get isAuthenticated {
    // print("isAuthenticated - ${user == null ? false : true}");
    return user == null ? false : true;
  }
}
