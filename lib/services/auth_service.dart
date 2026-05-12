import 'package:http/http.dart' as http;

import '../core/api/api_client.dart';
import '../core/api/endpoints/auth_endpoints.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({http.Client? httpClient, ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(httpClient: httpClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final payload = {
      'email': email,
      'password': password,
      'device_name': 'mobile_app',
    };

    dynamic response;
    try {
      response = await _apiClient.post(
        AuthEndpoints.mobileLogin,
        authenticated: false,
        body: payload,
      );
    } catch (_) {
      response = await _apiClient.post(
        AuthEndpoints.token,
        authenticated: false,
        body: payload,
      );
    }

    final data = _asMap(response);
    await _storeAuthData(data);
    return data;
  }

  Future<void> logout() async {
    try {
      final token = await _apiClient.readToken();
      if (token != null) {
        await _apiClient.post(AuthEndpoints.logout);
      }
    } catch (_) {
      // Ignore logout errors, then clear local auth.
    } finally {
      await _clearAuthData();
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _apiClient.readToken();
      if (token == null) return null;

      try {
        return _asMap(await _apiClient.get(AuthEndpoints.mobileMe));
      } catch (_) {
        return _asMap(await _apiClient.get(AuthEndpoints.me));
      }
    } catch (_) {
      return null;
    }
  }

  Future<String?> getToken() => _apiClient.readToken();

  Future<bool> updateProfile({required String name, required String email}) async {
    try {
      final token = await _apiClient.readToken();
      if (token == null) return false;

      final data = _asMap(
        await _apiClient.put(
          AuthEndpoints.me,
          body: {'name': name, 'email': email},
        ),
      );
      final user = _extractUser(data);
      if (user != null) {
        await _apiClient.writeUser(user);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _storeAuthData(Map<String, dynamic> data) async {
    final wrapped = data['data'];
    final token = data['token'] ??
        data['access_token'] ??
        (wrapped is Map ? wrapped['token'] : null) ??
        (wrapped is Map ? wrapped['access_token'] : null);
    final user = _extractUser(data);

    if (token == null) {
      throw Exception('لم يرجع الخادم رمز الدخول');
    }

    await _apiClient.writeToken('$token');
    if (user != null) {
      await _apiClient.writeUser(user);
    }
  }

  Future<void> _clearAuthData() => _apiClient.clearAuth();

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _extractUser(Map<String, dynamic> data) {
    if (data['user'] is Map) {
      return Map<String, dynamic>.from(data['user'] as Map);
    }
    final wrapped = data['data'];
    if (wrapped is Map && wrapped['user'] is Map) {
      return Map<String, dynamic>.from(wrapped['user'] as Map);
    }
    if (wrapped is Map && wrapped.containsKey('id')) {
      return Map<String, dynamic>.from(wrapped);
    }
    if (data.containsKey('id')) return data;
    return null;
  }

  void dispose() {
    _apiClient.dispose();
  }
}

