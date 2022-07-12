import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/auth/models/auth_user_form.dart';

class AuthApiService {
  static final _supabase = Supabase.instance;

  static Future<void> signIn(AuthUserForm authUserForm) async {
    print("AuthService - signIn");
    try {
      final result = await _supabase.client.auth.signIn(
        email: authUserForm.email!,
        password: authUserForm.password!,
      );
      if (result.error != null)
        throw SupabaseException("Supabase error", result.error!.message);
      if (result.user == null)
        throw SupabaseException("Supabase error", "Error Sign In.");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<void> signUp(AuthUserForm authUserForm) async {
    try {
      Map<String, dynamic> params = {
        "in_login": authUserForm.login,
        "in_email": authUserForm.email,
      };

      final isUserExists = await checkIfUserExists(params);
      if (isUserExists.containsValue(true)) {
        List<String> message = [];

        if (isUserExists["result_login"]) {
          message.add("Such login already exist.");
        }
        if (isUserExists["result_email"]) {
          message.add("Such email already exist.");
        }
        throw SupabaseException(
          "Sign Up error",
          message.join(" "),
          KindOfException.auth,
        );
      }

      final result = await _supabase.client.auth
          .signUp(authUserForm.email!, authUserForm.password!);

      if (result.error != null)
        throw SupabaseException("Supabase error", result.error!.message);
      if (result.user == null)
        throw SupabaseException("Supabase error", "Error Sign Up.");

      final createdUser = _supabase.client.auth.currentUser;

      final recordedUser = await _supabase.client
          .from("users")
          .insert(authUserForm.toJson()
            ..addAll({
              "id": createdUser?.id,
              "createdAt": createdUser?.createdAt,
            }))
          .execute();

      final recordedSunbscription =
          await _supabase.client.from("subscriptions").insert({
        "id": createdUser?.id,
        "subscriptionTo": createdUser?.id,
      }).execute();
    } on SupabaseException catch (e) {
      print("AuthService - signUp - SupabaseException - e: $e");
      rethrow;
    } catch (e) {
      print("AuthService - signUp - e: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> checkIfUserExists(
      Map<String, dynamic> params) async {
    try {
      // print(params);
      final recordedUser = await _supabase.client
          .rpc(
            "check_if_user_exist",
            params: params,
          )
          .execute();
      // print(recordedUser.toJson());

      return recordedUser.data;
    } catch (e) {
      print("AuthService - checkIfLoginExists - e: $e");
      rethrow;
    }
  }
}
