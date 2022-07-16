import 'package:supabase_flutter/supabase_flutter.dart';

class NavigatorService {
  static final _supabase = Supabase.instance;

  static Future<void> signOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
