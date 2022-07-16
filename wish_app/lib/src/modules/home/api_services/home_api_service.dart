import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/models/wish.dart';

class HomeService {
  static final _supabase = Supabase.instance;
  static Future<List<Wish>?> loadWishList({
    required int limit,
    required int offset,
    String? currentUserId,
  }) async {
    try {
      final curentUserId = _supabase.client.auth.currentUser?.id;

      Map<String, dynamic> params = {
        "limit": limit,
        "offset": offset,
      };
      if (currentUserId != null) {
        params.addAll({"user_id": curentUserId!});
      }

      final selectedQuery = await _supabase.client
          .rpc(
            "select_wish_list",
            params: params,
          )
          .execute();

      if (selectedQuery.hasError) {
        // throw SupabaseException("Supabase Error", selectedQuery.error!.message);
        throw SupabaseException(
            "error_db_unknown_title".tr, selectedQuery.error!.message);
      }

      final lastWishList = (selectedQuery.data as List<dynamic>)
          .map((item) =>
              Wish.fromJson(item as Map<String, dynamic>, curentUserId))
          .toList();

      return lastWishList;
    } on SupabaseException catch (e) {
      print("HomeService - loadWishList - SupabaseException - ${e.toString()}");
      rethrow;
    } catch (e) {
      print("HomeService - loadWishList - SupabaseException - $e");
      // throw UnknownException("Unknown error");
      rethrow;
    }
  }

  static Future<int?> countOfWishInSubscriptions({
    required String? currentUserId,
  }) async {
    try {
      final curentUserId = _supabase.client.auth.currentUser?.id;
      Map<String, dynamic> params = {};
      if (currentUserId != null) {
        params.addAll({"user_id": curentUserId});
      }

      final countWish = await _supabase.client
          .rpc(
            "count_of_wish_in_subscriptions",
            params: params,
          )
          .execute();

      if (countWish.hasError) {
        // throw SupabaseException("Supabase Error", countWish.error!.message);
        throw SupabaseException(
            "error_db_unknown_title".tr, countWish.error!.message);
      }

      print(countWish.data);
      return countWish.data;
    } on SupabaseException catch (e) {
      print("HomeService - loadCountOfWishInSubscriptions - ${e.toString()}");
      rethrow;
    } catch (e) {
      print("HomeService - loadCountOfWishInSubscriptions - $e");
      // throw UnknownException("Unknown error");
      rethrow;
    }
  }
}
