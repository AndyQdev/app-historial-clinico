class AppConfig {
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'MyApp');
  static const String appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  static const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'development');
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');
}
