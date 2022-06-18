import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/api_services/user_api_service.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/user_account.dart';
import 'package:wish_app/src/models/wish.dart';

class AccountApiService {
  static final _supabase = Supabase.instance.client;

  // getUser
  static Future<UserAccount?> getUser(String id, String? currentUserId) async {
    try {
      final theUser = await UserApiService.getUser(id, currentUserId);

      final gotUserInfo = await getUserInfo(id);
      // print("AccountApiService - getUser - gotUserInfo : ${gotUserInfo}");

      theUser!.setUserInfoFromMap(gotUserInfo!);

      return theUser;
    } catch (e) {
      print("AccountApiService - getUser() - e : $e");
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

      print(params);

      final gotTheWishes = await _supabase
          .rpc(
            "select_user_wish_list",
            params: params,
          )
          .execute();

      if (gotTheWishes.hasError) {
        throw SupabaseException("Error", gotTheWishes.error!.message);
      }

      final theWishes = (gotTheWishes.data as List<dynamic>)
          .map((wish) =>
              Wish.fromJson(wish as Map<String, dynamic>, currentUserId))
          .toList();

      // print(
      //     'AccountApiService - getTheUserWishes() - theWishes : ${theWishes}');

      return theWishes;
    } on SupabaseException catch (e) {
      print(
          "AccountApiService - getTheUserWishes() - SupabaseException - e : $e");
      rethrow;
    } catch (e) {
      print("AccountApiService - getTheUserWishes() - e : $e");

      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserInfo(String id) async {
    try {
      final gotUserInfo = await UserApiService.getUserInfo(id);
      return gotUserInfo;
    } on SupabaseException catch (e) {
      print("AccountApiService - getUserInfo() - SupabaseException - e : $e");

      rethrow;
    } catch (e) {
      print("AccountApiService - getUserInfo() - e : $e");
      rethrow;
    }
  }
}
