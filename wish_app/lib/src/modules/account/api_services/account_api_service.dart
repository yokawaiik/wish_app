import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../global/api_services/user_api_service.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/models/user_account.dart';
import '../../global/models/wish.dart';

class AccountApiService {
  static final _supabase = Supabase.instance.client;

  static Future<UserAccount?> getUser(String id, String? currentUserId) async {
    try {
      final theUser = await UserApiService.getUser(id, currentUserId);

      if (theUser == null) {
        throw SupabaseException(
            "error_title".tr, "account_aas_es_such_an_user_did_not_find".tr);
      }

      final gotUserInfo = await getUserInfo(id);

      if (currentUserId != null) {
        final gotSubscriptionInfo =
            await getSubscriptionInfo(currentUserId, id);
        theUser.setSubscriptionInfoFromMap(gotSubscriptionInfo!);
      }

      theUser.setUserInfoFromMap(gotUserInfo!);

      return theUser;
    } catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getUser() - e : $e");
      }
      rethrow;
    }
  }

  static Future<List<Wish>?> getTheUserWishes(
    String id, {
    int? limit = 10,
    int? offset = 0,
    String? currentUserId,
  }) async {
    try {
      final params = {
        "in_user_id": id,
        "limit": limit,
        "offset": offset,
      };

      final gotTheWishes = await _supabase
          .rpc(
            "select_user_wish_list",
            params: params,
          )
          .execute();

      if (gotTheWishes.hasError) {
        throw SupabaseException("error_title".tr, gotTheWishes.error!.message);
      }

      final theWishes = (gotTheWishes.data as List<dynamic>)
          .map((wish) =>
              Wish.fromJson(wish as Map<String, dynamic>, currentUserId))
          .toList();

      return theWishes;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "AccountApiService - getTheUserWishes() - SupabaseException - e : $e");
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getTheUserWishes() - e : $e");
      }

      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserInfo(String id) async {
    try {
      final gotUserInfo = await UserApiService.getUserInfo(id);
      return gotUserInfo;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getUserInfo() - SupabaseException - e : $e");
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getUserInfo() - e : $e");
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getSubscriptionInfo(
    String currentUserId,
    String anotherUserId,
  ) async {
    try {
      final params = {
        "in_current_user_id": currentUserId,
        "in_another_user_id": anotherUserId,
      };

      final gotSubscriptionInfo = await _supabase
          .rpc(
            "check_subscription",
            params: params,
          )
          .execute();

      if (gotSubscriptionInfo.hasError) {
        throw SupabaseException("error_title".tr,
            "account_aas_es_error_when_get_subscription_info".tr);
      }

      return gotSubscriptionInfo.data as Map<String, dynamic>?;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "AccountApiService - getSubscriptionInfo() - SupabaseException - e : $e");
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getSubscriptionInfo() - e : $e");
      }
      rethrow;
    }
  }

  static Future<bool?> subscribe(
    String currentUserId,
    String anotherUserId,
  ) async {
    try {
      final params = {
        "in_current_user_id": currentUserId,
        "in_another_user_id": anotherUserId,
      };

      final gotSubscriptionInfo = await _supabase
          .rpc(
            "toggle_subscription",
            params: params,
          )
          .execute();

      if (gotSubscriptionInfo.hasError) {
        throw SupabaseException(
          "error_title".tr,
          gotSubscriptionInfo.error.toString(),
        );
      }

      return gotSubscriptionInfo.data;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "AccountApiService - getSubscriptionInfo() - SupabaseException - e : $e");
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("AccountApiService - getSubscriptionInfo() - e : $e");
      }
      rethrow;
    }
  }
}
