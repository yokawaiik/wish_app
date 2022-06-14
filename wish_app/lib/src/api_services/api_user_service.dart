import 'package:wish_app/src/models/user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiUserService {
  static final _supabase = Supabase.instance.client;

  static Future<UserAccount?> getUser(String id, String? currentUserId) async {
    try {
      final theGotUser = (await _supabase
              .from("users")
              .select("*")
              .eq("id", id)
              .single()
              .execute())
          .data;
      print("ApiUserService - getUser() - theGotUser : $theGotUser");
      final theUser = UserAccount.fromJson(theGotUser, currentUserId);
      print("ApiUserService - getUser() - theUser : $theUser");

      return theUser;
    } catch (e) {
      print("ApiUserService - getUser() - e : $e");
      rethrow;
    }
  }
}
