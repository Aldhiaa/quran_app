import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _httpClient;
  final FlutterSecureStorage _storage;
  final String baseUrl;

  ApiClient({
    http.Client? httpClient,
    FlutterSecureStorage? storage,
    this.baseUrl = AppConfig.apiBaseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<dynamic> get(
    String path, {
    bool authenticated = true,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      'GET',
      path,
      authenticated: authenticated,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> post(
    String path, {
    bool authenticated = true,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      'POST',
      path,
      authenticated: authenticated,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> put(
    String path, {
    bool authenticated = true,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      'PUT',
      path,
      authenticated: authenticated,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> delete(
    String path, {
    bool authenticated = true,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      'DELETE',
      path,
      authenticated: authenticated,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> _send(
    String method,
    String path, {
    required bool authenticated,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _uri(path, queryParameters);
      final headers = await _headers(authenticated);
      final encodedBody = body == null ? null : jsonEncode(body);

      final Future<http.Response> request = switch (method) {
        'GET' => _httpClient.get(uri, headers: headers),
        'POST' => _httpClient.post(uri, headers: headers, body: encodedBody),
        'PUT' => _httpClient.put(uri, headers: headers, body: encodedBody),
        'DELETE' => _httpClient.delete(uri, headers: headers),
        _ => throw const ApiException('طريقة الطلب غير مدعومة'),
      };

      final response = await request.timeout(AppConfig.apiTimeout);

      return _parseResponse(response);
    } on SocketException catch (e) {
      throw ApiException('لا يوجد اتصال بالإنترنت', cause: e);
    } on TimeoutException catch (e) {
      throw ApiException('انتهت مهلة الاتصال بالخادم', cause: e);
    } on FormatException catch (e) {
      throw ApiException('استجابة الخادم غير صالحة', cause: e);
    } on http.ClientException catch (e) {
      throw ApiException('تعذر الاتصال بالخادم', cause: e);
    }
  }

  Uri _uri(String path, Map<String, dynamic>? queryParameters) {
    final raw = path.startsWith('http') ? path : '$baseUrl$path';
    final uri = Uri.parse(raw);
    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParameters.map((key, value) => MapEntry(key, '$value')),
      },
    );
  }

  Future<Map<String, String>> _headers(bool authenticated) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authenticated) {
      final token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        throw const ApiException('غير مصرح به');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  dynamic _parseResponse(http.Response response) {
    final text = response.body.trim();
    final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = decoded is Map
        ? (decoded['message'] ?? decoded['error'] ?? 'فشل الطلب')
        : 'فشل الطلب';
    throw ApiException(
      '$message',
      statusCode: response.statusCode,
    );
  }

  Future<void> writeToken(String token) => _storage.write(key: 'token', value: token);

  Future<String?> readToken() => _storage.read(key: 'token');

  Future<void> writeUser(Map<String, dynamic> user) {
    return _storage.write(key: 'user', value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> readStoredUser() async {
    final raw = await _storage.read(key: 'user');
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : Map<String, dynamic>.from(decoded as Map);
  }

  Future<void> clearAuth() => _storage.deleteAll();

  void dispose() {
    _httpClient.close();
  }
}
