import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../global/models/supabase_exception.dart';
import '../../global/models/wish.dart';

class FavoritesApiService {
  static final _supabase = Supabase.instance;

  static Future<void> toggleFavorite(int wishId, String currentUserId) async {
    try {
      final params = {
        "in_wish_id": wishId,
        "in_user_id": currentUserId,
      };

      await _supabase.client
          .rpc(
            "toggle_favorite",
            params: params,
          )
          .execute();
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "FavoritesApiService - toggleFavorite - SupabaseException - e : ${e.toString()}");
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("FavoritesApiService - toggleFavorite - e : $e");
      }
      rethrow;
    }
  }

  static Future<int?> getCountOfFavorites(String currentUserId) async {
    try {
      final params = {
        "in_user_id": currentUserId,
      };

      final addedFavoriteWish = await _supabase.client
          .rpc(
            "count_of_favorites",
            params: params,
          )
          .execute();

      if (addedFavoriteWish.hasError) {
        throw SupabaseException(
          "error_title".tr,
          "fm_fas_es_get_count_of_favorites".tr,
        );
      }

      return addedFavoriteWish.data;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "FavoritesApiService - _deleteFavoriteWish - SupabaseException - e : ${e.toString()}");
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("FavoritesApiService - _getAddedFavoriteWish - e : $e");
      }
      return null;
    }
  }

  static Future<List<Wish>?> loadFavoriteWishList({
    int limit = 10,
    int offset = 0,
    required String currentUserId,
  }) async {
    try {
      final params = {
        "in_user_id": currentUserId,
        "in_limit": limit,
        "in_offset": offset,
      };

      final gotWishList = await _supabase.client
          .rpc(
            "select_favorite_wish_list",
            params: params,
          )
          .execute();

      if (gotWishList.hasError) {
        throw SupabaseException("error_title".tr, gotWishList.error!.message);
      }

      final theWishes = (gotWishList.data as List<dynamic>)
          .map((wish) => Wish.fromJson(
                wish as Map<String, dynamic>,
                currentUserId,
                isFavorite: true,
              ))
          .toList();

      return theWishes;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            "FavoritesApiService - loadFavoriteWishList() - SupabaseException - e : $e");
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("FavoritesApiService - loadFavoriteWishList() - e : $e");
      }

      rethrow;
    }
  }
}
