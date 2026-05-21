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
        return const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'http://localhost:3000',
        );
    }
  }

  static bool get isDevelopment => current == Environment.development;
  static bool get isProduction => current == Environment.production;
}
