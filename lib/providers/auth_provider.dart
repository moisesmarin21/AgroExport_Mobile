import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_session.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  bool isLoading = false;
  AuthSession? session;
  String? error;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      session = await _authService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', session!.token);

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword (String email) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      rethrow; 
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyCode (String email, String code) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.verifyCode(email, code);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      rethrow; 
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword (String email, String newPassword) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email, newPassword);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔐 Eliminar solo datos de sesión
    await prefs.remove('token');

    // Atajos de logueo:
    // remember_me
    // saved_username

    session = null;
    error = null;

    notifyListeners();
  }
}
