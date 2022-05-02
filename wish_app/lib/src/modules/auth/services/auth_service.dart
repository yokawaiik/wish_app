import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/supabase_exception.dart';
import 'package:wish_app/src/modules/auth/models/auth_user_form.dart';

class AuthService {
  static final _supabase = Supabase.instance;

  static Future<void> signIn(AuthUserForm authUserForm) async {
    print("AuthService > signIn");
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
      // UnknownException("Error login","It happened unknown error.")
      rethrow;
    }
  }

  static Future<void> signUp(AuthUserForm authUserForm) async {
    try {
      final result = await _supabase.client.auth.signUp(
        authUserForm.email!,
        authUserForm.password!,
      );

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

      final recordedSunscription =
          await _supabase.client.from("subscriptions").insert({
        "id": createdUser?.id,
        "subscriptionTo": createdUser?.id,
      }).execute();
    } catch (e) {
      rethrow;
    }
  }
}
