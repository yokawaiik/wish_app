import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/api_services/user_api_service.dart';
import 'package:wish_app/src/models/current_user.dart';
import 'package:wish_app/src/models/supabase_exception.dart';

class UserService extends GetxService {
  final _supabase = Supabase.instance;

  Future<UserService> init() async => this;

  CurrentUser? _currentUser;

  CurrentUser? get currentUser => _currentUser;

  Timer? _sessionTimer;

  RxBool get isUserAuthenticated {
    return RxBool(currentUser == null ? false : true);
  }

  @override
  void onInit() {
    _tryAutoLogin();

    // _supabase.client.auth.onAuthStateChange((event, session) {
    //   print('_supabase.client.auth.onAuthStateChange - event : ${event.name}');
    //   if (event.name == 'signedOut') {
    //     print("currentUser is SIGNED_OUT");
    //   } else if (event.name == 'signedIn') {
    //     print("currentUser is signedIn");
    //   } else {
    //     print("currentUser is null");
    //   }
    //   _setUser();
    // });
    super.onInit();
  }

  void _tryAutoLogin() {
    _setUser();

    if (_currentUser != null && !_sessionIsValid()) {
      _recoverSession();

      _startTimer();
    }
  }

  void _startTimer() {
    _sessionTimer?.cancel();
    var duration = _supabase.client.auth.currentSession!.expiresIn!;
    _sessionTimer = Timer(
      Duration(seconds: duration),
      (() {
        _recoverSession();
        _startTimer();
      }),
    );
  }

  void _setUser() {
    final authUser = _supabase.client.auth.currentUser;
    if (authUser == null) {
      _currentUser = null;
    } else {
      _currentUser = CurrentUser(
        id: authUser.id,
        appMetadata: authUser.appMetadata,
        userMetadata: authUser.userMetadata,
        aud: authUser.aud,
        email: authUser.email,
        phone: authUser.phone,
        createdAt: authUser.createdAt,
      );
    }
  }

  void _recoverSession() async {
    try {
      final refreshedSession = await _supabase.client.auth.refreshSession();
      if (refreshedSession.error != null) {
        throw SupabaseException(
          "Error",
          "JWT expired.",
          KindOfException.jwtExpired,
        );
      }
      _startTimer();
      // await _updateApp();
    } on SupabaseException catch (e) {
      print('UserService - _recoverSession - SupabaseException - e : $e');

      await _destroySession();
      // await _updateApp();
    } catch (e) {
      print('UserService - _recoverSession - e : $e');
      await _destroySession();
      // await _updateApp();
    } finally {
      await _updateApp();
    }
  }

  Future<void> _destroySession() async {
    _sessionTimer?.cancel();
    await UserApiService.signOut();

    _setUser();
  }

  bool _sessionIsValid() {
    final timeNow = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final expiresAt = _supabase.client.auth.currentSession?.expiresAt;

    if (expiresAt == null) return false;
    if (expiresAt < timeNow) return true;

    return false;
  }

  Future<void> _updateApp() async {
    await Get.forceAppUpdate();
  }

  // ? info: methods for another controllers
  Future<void> signOut() async {
    await _destroySession();
    await _updateApp();
  }

  void signIn() {
    _setUser();
    _startTimer();
    _updateApp();
  }

  void signUp() {
    _setUser();
    _startTimer();
    _updateApp();
  }
}
