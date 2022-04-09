import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/auth/models/auth_user_form.dart';

class AuthService {
  static final _supabase = Supabase.instance;

  static Future<void> signIn(AuthUserForm authUserForm) async {
    try {
      final result = await _supabase.client.auth.signIn(
        email: authUserForm.email!,
        password: authUserForm.password!,
      );

      if (result.error == null) throw SupabaseException(result.error?.message);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signUp(AuthUserForm authUserForm) async {
    try {
      await _supabase.client.auth.signUp(
        authUserForm.email!,
        authUserForm.password!,
      );

      final createdUser = _supabase.client.auth.currentUser;
      await _supabase.client.from("users").insert({
        authUserForm.email,
        authUserForm.login,
        createdUser?.createdAt
      }).execute();
    } catch (e) {
      rethrow;
    }
  }
}
