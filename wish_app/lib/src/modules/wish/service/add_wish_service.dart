import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';

class AddWishService {
  static final _supabase = Supabase.instance.client;

  static Future<void> addWish(WishForm wishForm) async {
    try {
      final result =
          await _supabase.from("wish").insert(wishForm.toJson()).execute();

      if (result.error != null)
        throw SupabaseException("Error", result.error.toString());

      wishForm.id = result.data[0]["id"];

      // todo: upload image
      if (wishForm.image != null) {
        final fileExt = wishForm.image?.path.split('.').last;
        final fileName = '${wishForm.id}-${wishForm.title}.$fileExt';
        final uploadedImageUrl =
            await uploadImage("wish/$fileName", wishForm.image!);

        wishForm.imageUrl = uploadedImageUrl;

        // todo: update record - insert imageUrl
        updateWish(wishForm);
      }
    } catch (e) {
      print('AddWishService - addWish: ${e}');
      throw SupabaseException("Error", "Error when add new wish");
    }
  }

  static Future<void> updateWish(WishForm wishForm) async {
    try {
      await _supabase
          .from("wish")
          .update(wishForm.toJson())
          .eq("id", wishForm.id)
          .execute();
    } catch (e) {
      print('AddWishService - updateWish: ${e}');
    }
  }

  static Future<void> deleteWish(WishForm wishForm) async {
    // todo: delete wish
  }

  static Future<String?> uploadImage(String path, File file) async {
    try {
      // await _supabase.storage.createBucket('wish.app.bucket');
      // final listBuckets = await _supabase.storage.listBuckets();
      // print(listBuckets.data?[0].id);

      final uploadResponse =
          // await _supabase.storage.from("wish").upload(

          await _supabase.storage.from("wish.app.bucket").upload(
                path,
                file,
              );
      if (uploadResponse.error != null)
        throw SupabaseException(
          "Error when upload image",
          uploadResponse.error.toString(),
        );

      final response =
          _supabase.storage.from("wish.app.bucket").getPublicUrl(path);
      return response.data;
    } catch (e) {
      print('AddWishService - uploadImage: ${e}');
    }
  }
}
