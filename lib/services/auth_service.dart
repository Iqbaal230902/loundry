import '../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// Authentication service handling login, register, and user profile API calls.
class AuthService {
  final ApiService _apiService;

  AuthService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Sets the auth token on the underlying API service.
  void setAuthToken(String? token) {
    _apiService.setAuthToken(token);
  }

  /// Logs in a user with email and password.
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiService.post(
      ApiConstants.login,
      body: request.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  /// Registers a new user.
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiService.post(
      ApiConstants.register,
      body: request.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  /// Fetches the current authenticated user's profile.
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get(ApiConstants.me);
    final data = response['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Disposes the API service.
  void dispose() {
    _apiService.dispose();
  }
}
