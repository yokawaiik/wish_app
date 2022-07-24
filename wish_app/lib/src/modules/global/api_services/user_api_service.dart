import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
        throw SupabaseException(
            "error_db_unknown_title".tr, 'gm_uas_es_error_getting_user'.tr);
      }

      return theUser;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print("UserApiService - getUser() - SupabaseException - e: $e");
      }

      rethrow;
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
        throw SupabaseException("error_db_unknown_title".tr,
            "gm_uas_es_error_getting_user_info".tr);
      }

      final userInfo = gotUserInfo.data as Map<String, dynamic>;

      return userInfo;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print("UserApiService - getUserInfo() - SupabaseException - e : $e");
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("UserApiService - getUserInfo() - e : $e");
      }

      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("UserApiService - signOut() - e : $e");
      }
      rethrow;
    }
  }
}
