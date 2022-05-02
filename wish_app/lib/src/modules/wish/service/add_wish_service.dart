import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/models/wish.dart';
import 'package:wish_app/src/modules/wish/models/wish_form.dart';

class AddWishService {
  static final _supabase = Supabase.instance.client;

  static Future<Wish?> addWish(WishForm wishForm) async {
    try {
      final result =
          await _supabase.from("wish").insert(wishForm.toJson()).execute();

      if (result.error != null) {
        throw SupabaseException("Error", result.error.toString());
      }

      wishForm.id = result.data[0]["id"];
      wishForm.createdAt = DateTime.tryParse(result.data[0]["createdAt"]);
      wishForm.createdBy = result.data[0]["createdBy"];

      if (wishForm.image != null) {
        final fileExt = wishForm.image?.path.split('.').last;
        final fileName = '${wishForm.id}-${wishForm.title}.$fileExt';
        final uploadedImageUrl =
            await uploadImage("wish/$fileName", wishForm.image!);

        wishForm.imageUrl = uploadedImageUrl;
        updateWish(wishForm);
      }


      print(wishForm.id!);
      print(wishForm.title!);
      print(wishForm.createdAt!);
      print(wishForm.createdBy!);

      final wish = Wish(
        id: wishForm.id!,
        title: wishForm.title!,
        createdAt: wishForm.createdAt!,
        createdBy: wishForm.createdBy!,
        description: wishForm.description,
        imageUrl: wishForm.imageUrl,
        link: wishForm.link,
        isCurrentUser: true,
      );

      return wish;
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
      final uploadResponse =
          await _supabase.storage.from("wish.app.bucket").upload(
                path,
                file,
              );
      if (uploadResponse.error != null) {
        throw SupabaseException(
          "Error when upload image",
          uploadResponse.error.toString(),
        );
      }

      final response =
          _supabase.storage.from("wish.app.bucket").getPublicUrl(path);
      return response.data;
    } catch (e) {
      print('AddWishService - uploadImage: ${e}');
    } finally {
      return null;
    }
  }
}
