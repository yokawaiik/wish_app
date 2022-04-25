import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';

class AddWishService {
  static final _supabase = Supabase.instance.client;

  static Future<void> addWish(WishForm wishForm) async {
    final result =
        await _supabase.from("wish").insert(wishForm.toJson()).execute();
    // todo: upload image

    // todo update record - insert imageUrl
    if (result.error != null)
      throw SupabaseException("Error", "Error when add new wish");
    print(result.data);
  }

  static Future<void> updateWish(WishForm wishForm) async {}

  static Future<String?> uploadImage() async {}
}
