import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/models/user_account.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  // todo: getUser
  static Future<UserAccount?> getUser() async {
    try {} catch (e) {}
  }

  // todo: getTheWishesOfUser
  static Future<UserAccount?> getTheWishesOfUser() async {
    try {} catch (e) {}
  }
}
