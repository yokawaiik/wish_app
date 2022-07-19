import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../global/models/light_user.dart';
import '../../global/models/light_wish.dart';

class WishesAndUsersSearchApiService {
  static final _supabase = Supabase.instance;

  // TODO: getSearchWishList
  static Future<List<LightWish>?> getSearchWishList(String query) async {
    try {
      final params = {
        "in_query": query,
        // "in_limit": ,
      };

      final gotLightWishList = await _supabase.client
          .rpc('search_light_wish_list', params: params)
          .execute();

      if (gotLightWishList.hasError) throw gotLightWishList.error!;

      final ligthUserList =
          (gotLightWishList.data as List<Map<String, dynamic>>)
              .map((data) => LightWish.fromMap(data))
              .toList();

      return ligthUserList;
    } catch (e) {
      if (kDebugMode) {
        print('WishesAndUsersSearchApiService - getSearchWishList() - e: $e');
      }
      rethrow;
    }
  }

  // TODO: getSearchUserList
  static Future<List<LightUser>?> getSearchUserList(
      String query, String? currentUserId) async {
    try {
      final params = {
        "in_query": query,
        "in_user_id": currentUserId,
        // "in_limit": ,
      };

      final gotLightUserList = await _supabase.client
          .rpc('search_ligth_wish_list', params: params)
          .execute();

      if (gotLightUserList.hasError) throw gotLightUserList.error!;

      final ligthWishList =
          (gotLightUserList.data as List<Map<String, dynamic>>)
              .map((data) => LightUser.fromMap(data))
              .toList();

      return ligthWishList;
    } catch (e) {
      if (kDebugMode) {
        print('WishesAndUsersSearchApiService - getSearchUserList() - e: $e');
      }
      rethrow;
    }
  }
}
