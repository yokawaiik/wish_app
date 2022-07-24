import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../api_services/user_api_service.dart';
import '../models/current_user.dart';
import '../models/supabase_exception.dart';

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
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print('UserService - _recoverSession - SupabaseException - e : $e');
      }

      await _destroySession();
    } catch (e) {
      if (kDebugMode) {
        print('UserService - _recoverSession - e : $e');
      }
      await _destroySession();
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
