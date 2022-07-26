import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
          "error_title".tr,
          "account_aeas_es_error_updating_password".tr,
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            'AccountEditApiService - updatePassword - SupabaseException- e : $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('AccountEditApiService - updatePassword - e : $e');
      }
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
          "error_title".tr,
          "account_aeas_es_error_updating_login".tr,
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            'AccountEditApiService - updateLogin - SupabaseException- e : $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('AccountEditApiService - updateLogin - e : $e');
      }
      rethrow;
    }
  }

  static Future<bool?> checkIfLoginExists(String newLogin) async {
    try {
      final params = {
        "in_login": newLogin,
        "in_email": null,
      };

      final response = await AuthApiService.checkIfUserExists(params);

      return response['result_login'] as bool;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            'AccountEditApiService - updateLogin - SupabaseException- e : $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('AccountEditApiService - updateLogin - e : $e');
      }
      rethrow;
    }
  }

  static Future<void> updateUserInfo(AccountEditUser userData) async {
    try {
      final response = await _supabase
          .from('users')
          .update(userData.toMap())
          .eq('id', userData.id)
          .execute();

      if (response.hasError) {
        throw SupabaseException(
          "error_title".tr,
          "account_aeas_es_error_updating_user_info".tr,
          KindOfException.auth,
        );
      }
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            'AccountEditApiService - updateUserInfo - SupabaseException- e : $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('AccountEditApiService - updateUserInfo - e : $e');
      }
      rethrow;
    }
  }

  static Future<String?> updateAccountImage(File file, String id) async {
    try {
      final imagePath = generateProfileImagePath(
        rawFilePath: file.path,
        id: id,
        inFolderName: 'users/$id',
      );

      await _supabase.storage.from("wish.app.bucket").upload(
            imagePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              cacheControl: '0',
            ),
          );

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
          "error_title".tr,
          "account_aeas_es_error_updating_user_avatar".tr,
          KindOfException.auth,
        );
      }
      return imageUrl;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print(
            'AccountEditApiService - updateUserInfo - SupabaseException- e : $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('AccountEditApiService - updateUserInfo - e : $e');
      }
      rethrow;
    }
  }
}
