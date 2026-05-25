import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/api_service.dart';

/// Authentication state enum.
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Provider managing authentication state across the app.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthState _authState = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  // --- Getters ---

  AuthState get authState => _authState;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _authState == AuthState.loading;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  // --- Actions ---

  /// Attempts auto-login using stored credentials.
  Future<void> tryAutoLogin() async {
    _setLoading();

    try {
      final user = await _repository.tryAutoLogin();
      if (user != null) {
        _user = user;
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.unauthenticated;
      }
    } catch (_) {
      _authState = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  /// Logs in with email and password.
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading();

    try {
      _user = await _repository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan. Silakan coba lagi.');
      return false;
    }
  }

  /// Registers a new user.
  Future<bool> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _setLoading();

    try {
      _user = await _repository.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan. Silakan coba lagi.');
      return false;
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _authState = AuthState.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Changes the user's password.
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _setLoading();
    try {
      await _repository.changePassword(oldPassword, newPassword);
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan. Silakan coba lagi.');
      return false;
    }
  }

  /// Updates the user's profile photo.
  Future<bool> updateProfilePhoto(File image) async {
    _setLoading();
    try {
      _user = await _repository.changeProfilePhoto(image);
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan saat mengunggah foto.');
      return false;
    }
  }

  // --- Private Helpers ---

  void _setLoading() {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _authState = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
