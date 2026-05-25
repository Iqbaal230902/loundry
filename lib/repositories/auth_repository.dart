import 'dart:io';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';

/// Repository coordinating between AuthService and SecureStorage.
///
/// Acts as the single source of truth for authentication state.
class AuthRepository {
  final AuthService _authService;
  final SecureStorageUtil _storage;

  AuthRepository({
    AuthService? authService,
    SecureStorageUtil? storage,
  })  : _authService = authService ?? AuthService(),
        _storage = storage ?? SecureStorageUtil();

  /// Logs in with email and password, stores token and user on success.
  Future<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final request = LoginRequest(email: email, password: password);
    final response = await _authService.login(request);

    if (!response.success || response.token == null || response.user == null) {
      throw ApiException(message: response.message);
    }

    // Persist token and user
    await _storage.saveToken(response.token!);
    await _storage.saveUser(response.user!);
    await _storage.setRememberMe(rememberMe);

    // Set token on service for future requests
    _authService.setAuthToken(response.token);

    return response.user!;
  }

  /// Registers a new user, stores token and user on success.
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final request = RegisterRequest(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
    final response = await _authService.register(request);

    if (!response.success || response.token == null || response.user == null) {
      throw ApiException(message: response.message);
    }

    // Persist token and user
    await _storage.saveToken(response.token!);
    await _storage.saveUser(response.user!);

    // Set token on service for future requests
    _authService.setAuthToken(response.token);

    return response.user!;
  }

  /// Attempts auto-login using a stored token.
  ///
  /// Returns the user if a valid token exists, null otherwise.
  Future<UserModel?> tryAutoLogin() async {
    final rememberMe = await _storage.getRememberMe();
    if (!rememberMe) {
      return null;
    }

    final token = await _storage.getToken();
    if (token == null) return null;

    // Set token and try to validate it
    _authService.setAuthToken(token);

    try {
      final user = await _authService.getCurrentUser();
      // Update cached user data
      await _storage.saveUser(user);
      return user;
    } catch (_) {
      // Token is invalid or expired
      await _storage.clearAll();
      _authService.setAuthToken(null);
      return null;
    }
  }

  /// Logs out the user and clears all stored data.
  Future<void> logout() async {
    await _storage.clearAll();
    _authService.setAuthToken(null);
  }

  /// Gets the cached user without network call.
  Future<UserModel?> getCachedUser() async {
    return await _storage.getUser();
  }

  /// Changes user password.
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authService.changePassword(oldPassword, newPassword);
  }

  /// Changes user profile photo.
  Future<UserModel> changeProfilePhoto(File image) async {
    final photoUrl = await _authService.changeProfilePhoto(image);
    final user = await _storage.getUser();
    if (user != null) {
      final updatedUser = user.copyWith(profilePhotoUrl: photoUrl);
      await _storage.saveUser(updatedUser);
      return updatedUser;
    }
    throw ApiException(message: 'User not found in local storage');
  }

  /// Disposes resources.
  void dispose() {
    _authService.dispose();
  }
}
