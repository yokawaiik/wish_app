import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/wish.dart';

class FavoritesApiService {
  static final _supabase = Supabase.instance;

  // todo: FavoritesApiService toggleFavorite
  static Future<bool?> toggleFavorite() async {}

  // todo: FavoritesApiService getCountOfFavorites
  static Future<int?> getCountOfFavorites(String currentUserId) async {
// count_of_favorites
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
          "Exception",
          "Exception when find an added favorite wish.",
        );
      }

      return addedFavoriteWish.data;
    } on SupabaseException catch (e) {
      print(
          "FavoritesApiService - _deleteFavoriteWish - SupabaseException - e : ${e.toString()}");
      return null;
    } catch (e) {
      print("FavoritesApiService - _getAddedFavoriteWish - e : $e");
      return null;
    }
  }

  static void addFavorite(
    void Function(Wish) callback,
    String currentUserId,
  ) {
    _supabase.client
        .from('favorites:userId=eq.${_supabase.client.auth.currentUser!.id}')
        .on(SupabaseEventTypes.insert, (payload) async {
      // todo: convert to model wish
      // todo: get wish
      final wishId = payload.newRecord!['wishId'];
      final gotWish = await _getAddedFavoriteWish(wishId, currentUserId);

      if (gotWish == null) return;

      callback(gotWish);
    }).subscribe();
  }

  // todo: test: deleteFavorite
  static void deleteFavorite(void Function(int) callback) {
    _supabase.client
        .from('favorites:userId=eq.${_supabase.client.auth.currentUser!.id}')
        .on(SupabaseEventTypes.delete, (payload) {
      callback(payload.oldRecord!["wishId"]);
    }).subscribe();
  }

  // todo: test: _getAddedFavoriteWish
  static Future<Wish?> _getAddedFavoriteWish(
    int wishId,
    String currentUserId,
  ) async {
    try {
      final params = {
        "in_wish_id": wishId,
        "in_user_id": currentUserId,
      };

      final addedFavoriteWish = await _supabase.client
          .rpc("get_added_favorite_wish", params: params)
          .execute();

      if (addedFavoriteWish.hasError) {
        throw SupabaseException(
          "Exception",
          "Exception when find an added favorite wish.",
        );
      }

      return Wish.fromJson(
        addedFavoriteWish.data,
        currentUserId,
        isFavorite: true,
      );
    } on SupabaseException catch (e) {
      print(
          "FavoritesApiService - _deleteFavoriteWish - SupabaseException - e : ${e.toString()}");
      return null;
    } catch (e) {
      print("FavoritesApiService - _getAddedFavoriteWish - e : $e");
      return null;
    }
  }

  // todo: test: deleteFavoriteWish
  static Future<bool> deleteFavoriteWish(int id) async {
    try {
      final deletedWish = await _supabase.client
          .from("favorites")
          .delete()
          .eq("wishId", id)
          .execute();
      if (deletedWish.hasError) {
        throw SupabaseException(
          "Exception",
          "Exception when delete favorite wish.",
        );
      }
      return true;
    } on SupabaseException catch (e) {
      print(
          "FavoritesApiService - _deleteFavoriteWish - SupabaseException - e : ${e.toString()}");
      return false;
    } catch (e) {
      print("FavoritesApiService - _deleteFavoriteWish - e : $e");
      return false;
    }
  }

  // static Future<List<Wish>?> loadFavoriteWishList(
  //   id, {
  //   required limit,
  //   required offset,
  //   required currentUserId,
  // }) async {

  // }

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

      print(params);

      final gotWishList = await _supabase.client
          .rpc(
            "select_favorite_wish_list",
            params: params,
          )
          .execute();

      // print(
      //     'FavoritesApiService - loadFavoriteWishList() - gotWishList.data : ${gotWishList.data}');

      if (gotWishList.hasError) {
        throw SupabaseException("Error", gotWishList.error!.message);
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
      print(
          "FavoritesApiService - loadFavoriteWishList() - SupabaseException - e : $e");
      rethrow;
    } catch (e) {
      print("FavoritesApiService - loadFavoriteWishList() - e : $e");

      rethrow;
    }
  }
}
