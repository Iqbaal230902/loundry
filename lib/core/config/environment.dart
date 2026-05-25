import 'dart:io';
import 'package:flutter/foundation.dart';

/// Environment configuration for the app.
///
/// Switch environment via build flags:
/// ```
/// flutter run --dart-define=ENV=production
/// ```
enum Environment { development, staging, production }

class EnvironmentConfig {
  EnvironmentConfig._();

  static const String _envKey = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static Environment get current {
    switch (_envKey) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.development;
    }
  }

  static String get baseUrl {
    switch (current) {
      case Environment.production:
        return const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'https://api.yourlaundryapp.com',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'https://staging-api.yourlaundryapp.com',
        );
      case Environment.development:
        String defaultUrl = 'http://localhost:3000';
        if (!kIsWeb && Platform.isAndroid) {
          defaultUrl = 'http://10.0.2.2:3000';
        }
        return String.fromEnvironment(
          'BASE_URL',
          defaultValue: defaultUrl,
        );
    }
  }

  static bool get isDevelopment => current == Environment.development;
  static bool get isProduction => current == Environment.production;
}
