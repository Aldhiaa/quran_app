import '../api_constants.dart';

class AppConfig {
  const AppConfig._();

  static const appName = 'نظام المنارة';
  static const apiBaseUrl = ApiConstants.baseUrl;
  static const apiTimeout = Duration(seconds: 20);
}

