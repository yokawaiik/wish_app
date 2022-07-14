import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/account/models/account_edit_user.dart';
import '../../auth/api_services/auth_api_service.dart';
import '../../global/models/supabase_exception.dart';
import '../../global/utils/generate_profile_image_path.dart';

class AccountEditApiService {
  static final _supabase = Supabase.instance.client;

  static Future<void> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.api.updateUser(
        _supabase.auth.currentSession!.accessToken,
        UserAttributes(
          password: newPassword,
        ),
      );

      if (response.error != null) {
        throw SupabaseException(
          "Error",
          "Error when update password.",
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      print(
          'AccountEditApiService - updatePassword - SupabaseException- e : $e');
      rethrow;
    } catch (e) {
      print('AccountEditApiService - updatePassword - e : $e');
      rethrow;
    }
  }

  static Future<void> updateLogin(String login, String id) async {
    try {
      final response = await _supabase
          .from('users')
          .update({'login': login})
          .eq('id', id)
          .execute();

      if (response.error != null) {
        throw SupabaseException(
          "Error",
          "Error when update password.",
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      print(
          'AccountEditApiService - updateLogin - SupabaseException- e : ${e}');
      rethrow;
    } catch (e) {
      print('AccountEditApiService - updateLogin - e : $e');
      rethrow;
    }
  }

  static Future<bool?> checkIfLoginExists(String newLogin) async {
    try {
      print(newLogin);

      final params = {
        "in_login": newLogin,
        "in_email": null,
      };

      final response = await AuthApiService.checkIfUserExists(params);

      // print(response);

      return response['result_login'] as bool;
    } on SupabaseException catch (e) {
      print(
          'AccountEditApiService - updateLogin - SupabaseException- e : ${e}');
      rethrow;
    } catch (e) {
      print('AccountEditApiService - updateLogin - e : $e');
      rethrow;
    }
  }

  // todo: updateUserInfo
  static Future<void> updateUserInfo(AccountEditUser userData) async {
    try {
      // _supabase.auth.api.resetPasswordForEmail(email);
      final response = await _supabase
          .from('users')
          .update(userData.toMap())
          .eq('id', userData.id)
          .execute();

      if (response.hasError) {
        throw SupabaseException(
          "Error",
          "Error when update user info.",
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      print(
          'AccountEditApiService - updateUserInfo - SupabaseException- e : $e');
      rethrow;
    } catch (e) {
      print('AccountEditApiService - updateUserInfo - e : $e');
      rethrow;
    }
  }

  // TODO: updateAccountImage
  static Future<String?> updateAccountImage(File file, String id) async {
    try {
      // _supabase.auth.api.resetPasswordForEmail(email);

      final imagePath = generateProfileImagePath(
        rawFilePath: file.path,
        id: id,
        inFolderName: 'users/$id',
      );

      final uploadResponse =
          await _supabase.storage.from("wish.app.bucket").upload(
                imagePath,
                file,
                fileOptions: const FileOptions(
                  upsert: true,
                  cacheControl: '0',
                ),
              );

      // final uploadResponse =
      //     await _supabase.storage.from("wish.app.bucket").updateBinary(
      //           imagePath,
      //           await file.readAsBytes(),
      //           fileOptions: const FileOptions(
      //             upsert: true,
      //             cacheControl: '0',
      //           ),
      //         );

      final imageUrl = _supabase.storage
          .from("wish.app.bucket")
          .getPublicUrl(imagePath)
          .data;

      final response = await _supabase
          .from('users')
          .update({"imageUrl": imageUrl})
          .eq("id", id)
          .execute();

      if (response.hasError) {
        throw SupabaseException(
          "Error",
          "Error when update user info.",
          KindOfException.auth,
        );
      }
      return imageUrl;
    } on SupabaseException catch (e) {
      print(
          'AccountEditApiService - updateUserInfo - SupabaseException- e : $e');
      rethrow;
    } catch (e) {
      print('AccountEditApiService - updateUserInfo - e : $e');
      rethrow;
    }
  }
}
