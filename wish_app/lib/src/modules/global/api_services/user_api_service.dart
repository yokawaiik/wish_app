import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supabase_exception.dart';
import '../models/user_account.dart';

class UserApiService {
  static final _supabase = Supabase.instance.client;

  static Future<UserAccount?> getUser(String id, String? currentUserId) async {
    try {
      final theGotUser = await _supabase
          .from("users")
          .select("*")
          .eq("id", id)
          .single()
          .execute();
      final theUser = UserAccount.fromJson(theGotUser.data, currentUserId);

      if (theGotUser.hasError) {
        throw SupabaseException("Error", theGotUser.error!.message);
      }

      return theUser;
    } on SupabaseException catch (e) {
      print("UserApiService - getUser() - SupabaseException - e: $e");

      throw SupabaseException("Error", "Something went wrong.");
    } catch (e) {
      print("UserApiService - getUser() - e : $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserInfo(String id) async {
    try {
      final gotUserInfo = await _supabase.rpc(
        "info_user",
        params: {
          "in_user_id": id,
        },
      ).execute();

      if (gotUserInfo.hasError) {
        throw SupabaseException("Error", gotUserInfo.error!.message);
      }

      final userInfo = gotUserInfo.data as Map<String, dynamic>;

      return userInfo;
    } on SupabaseException catch (e) {
      print("UserApiService - getUserInfo() - SupabaseException - e : $e");

      rethrow;
    } catch (e) {
      print("UserApiService - getUserInfo() - e : $e");

      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print("UserApiService - signOut() - e : $e");
      rethrow;
    }
  }
}
