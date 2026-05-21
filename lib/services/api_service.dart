import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/config/environment.dart';
import '../core/constants/api_constants.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Generic HTTP client wrapper for REST API communication.
class ApiService {
  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Sets the authentication token for subsequent requests.
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Builds the full URL from a path.
  Uri _buildUri(String path) {
    return Uri.parse('${EnvironmentConfig.baseUrl}$path');
  }

  /// Builds headers with optional auth token.
  Map<String, String> _buildHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': ApiConstants.contentType,
      'Accept': ApiConstants.contentType,
    };
    if (_authToken != null) {
      headers[ApiConstants.authorization] =
          '${ApiConstants.bearer} $_authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  /// Parses the response and throws [ApiException] on error.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      message: body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
      errors: body['errors'] as Map<String, dynamic>?,
    );
  }

  /// Performs a GET request.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .get(
            _buildUri(path),
            headers: _buildHeaders(extra: headers),
          )
          .timeout(ApiConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } on TimeoutException {
      throw const ApiException(
        message: 'Koneksi timeout. Silakan coba lagi',
        statusCode: 0,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Terjadi kesalahan: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Performs a POST request.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .post(
            _buildUri(path),
            headers: _buildHeaders(extra: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } on TimeoutException {
      throw const ApiException(
        message: 'Koneksi timeout. Silakan coba lagi',
        statusCode: 0,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Terjadi kesalahan: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Closes the HTTP client.
  void dispose() {
    _client.close();
  }
}
