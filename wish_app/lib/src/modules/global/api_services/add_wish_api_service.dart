import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wish_app/src/modules/wish/models/wish_form.dart';

import '../models/supabase_exception.dart';
import '../models/wish.dart';
import '../utils/generate_wish_image_path.dart';

class AddWishApiService {
  static final _supabase = Supabase.instance.client;

  static Future<Wish?> addWish(WishForm wishForm) async {
    try {
      final result = await _supabase
          .from("wish")
          .insert(wishForm.toJson()..remove("id"))
          .execute();

      if (result.error != null) {
        // throw SupabaseException("Error", result.error.toString());
        throw SupabaseException("error_title".tr, result.error.toString());
      }

      wishForm.id = result.data[0]["id"];
      wishForm.createdAt = DateTime.tryParse(result.data[0]["createdAt"]);
      wishForm.createdBy = result.data[0]["createdBy"];

      if (wishForm.image != null) {
        final imagePath = generateWishImagePath(
          wishForm.image!.path,
          wishForm.id.toString(),
        );

        final uploadedImageUrl = await uploadImage(imagePath, wishForm.image!);

        wishForm.imageUrl = uploadedImageUrl;
        await _updateWish(wishForm);
      }

      final addedWish = (await _supabase
              .from("wishes_view")
              .select()
              .eq("id", wishForm.id)
              .single()
              .execute())
          .data as Map<String, dynamic>;

      final wish = Wish.fromJson(addedWish, wishForm.createdBy);

      // print(wish);

      return wish;
    } catch (e) {
      print('AddWishService - addWish: ${e}');
      // throw SupabaseException("Error", "Error when add new wish");
      throw SupabaseException(
          "error_title".tr, "gm_awas_es_error_adding_wish".tr);
    }
  }

  static Future<void> _updateWish(WishForm wishForm) async {
    try {
      await _supabase
          .from("wish")
          .update(wishForm.toJson()..remove("id"))
          .eq("id", wishForm.id)
          .execute();
    } catch (e) {
      print('AddWishService - _updateWish: ${e}');
    }
  }

  static Future<Wish?> updateWish(
    WishForm wishForm,
    String currentUserId,
  ) async {
    try {
      if (wishForm.wasImageUpdate) {
        // print(wishForm.imageUrl);
        // print(wishForm.image!.path);

        final imagePath = generateWishImagePath(
          wishForm.imageUrl ?? wishForm.image!.path,
          wishForm.id.toString(),
        );

        // print(imagePath);

        // await removeImage(imagePath);

        final uploadedImageUrl = await uploadImage(
          imagePath,
          wishForm.image!,
        );

        wishForm.imageUrl = uploadedImageUrl;
      }

      final updatedTheWish = await _supabase
          .from("wish")
          .update(wishForm.toJson()..remove("id"))
          .eq("id", wishForm.id)
          .single()
          .execute();

      if (updatedTheWish.hasError)
        // throw SupabaseException(
        //   "Database error",
        //   "Such the wish was deleted or another error.",
        // );
        throw SupabaseException(
          "error_db_unknown_title".tr,
          "gm_awas_es_error_updating".tr,
        );

      getWish(wishForm.id!, currentUserId);

      final theWish = getWish(wishForm.id!, currentUserId);

      return theWish;
    } on SupabaseException catch (e) {
      print('AddWishService - updateWish - SupabaseException: ${e}');
      rethrow;
    } catch (e) {
      print('AddWishService - updateWish - e: ${e}');
      rethrow;
    }
  }

  static Future<void> deleteWish(int id, String? imagePath) async {
    try {
      await _supabase.from("wish").delete().eq("id", id).single().execute();

      if (imagePath != null) {
        await removeImage(imagePath);
      }
    } catch (e) {
      print('AddWishService - deleteWish - e: ${e}');
      rethrow;
    }
  }

  static Future<void> removeImage(String path) async {
    try {
      print('removeImage - path : $path');
      final removedResponse =
          await _supabase.storage.from("wish.app.bucket").remove([path]);

      if (removedResponse.error != null) {
        // throw SupabaseException(
        //   "Error when removed image",
        //   removedResponse.error.toString(),
        // );
        throw SupabaseException(
          "error_db_unknown_title".tr,
          'gm_awas_es_error_removing_image'.tr,
        );
      }
      print("removedResponse.data : ${removedResponse.data}");
    } on SupabaseException catch (e) {
      print('AddWishService - removeImage - SupabaseException : ${e}');
      rethrow;
    } catch (e) {
      print('AddWishService - removeImage: ${e}');
      rethrow;
    }
  }

  static Future<String?> uploadImage(String path, File file) async {
    try {
      final uploadResponse =
          await _supabase.storage.from("wish.app.bucket").upload(
                path,
                file,
                fileOptions: const FileOptions(
                  upsert: true,
                  cacheControl: '0',
                ),
              );
      if (uploadResponse.error != null) {
        // throw SupabaseException(
        //   "Error when upload image",
        //   uploadResponse.error.toString(),
        // );
        throw SupabaseException(
          "error_db_unknown_title".tr,
          "gm_awas_es_error_uploading_image".tr,
        );
      }

      final response =
          _supabase.storage.from("wish.app.bucket").getPublicUrl(path);

      print("uploadImage - response: ${response.data}");

      return response.data;
    } catch (e) {
      print('AddWishService - uploadImage: ${e}');
      rethrow;
    }
  }

  static Future<Wish?> getWish(int id, String currentUserId) async {
    try {
      final gotTheWish = await _supabase
          .from("wishes_view")
          .select()
          .eq("id", id)
          .single()
          .execute();

      if (gotTheWish.data == null) return null;

      // print('AddWishService - getWish - gotTheWish.data : ${gotTheWish.data}');

      final theWish =
          Wish.fromJson(gotTheWish.data as Map<String, dynamic>, currentUserId);

      return theWish;
    } catch (e) {
      print('AddWishService - getWish: ${e}');
      rethrow;
    }
  }
}
