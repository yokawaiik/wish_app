import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/current_user.dart';

class UserService extends GetxService {
  final _supabase = Supabase.instance;

  CurrentUser? get currentUser {
    _supabase.client.auth.onAuthStateChange((event, session) {
      print("currentUser - onAuthStateChange $event");
      // if (event == AuthChangeEvent.signedOut) {
      //   return null;
      // }
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
}
