import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final http.Client _httpClient;

  AuthService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiConstants.token),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': 'mobile_app',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storeAuthData(data);
        return data;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'فشل تسجيل الدخول: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('فشل الاتصال بالخادم: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('فشل الاتصال بالخادم: ${e.message}');
    } on FormatException catch (_) {
      throw Exception('خطأ في استجابة الخادم');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token != null) {
        await _httpClient.post(
          Uri.parse(ApiConstants.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      await _clearAuthData();
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return null;

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.me),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async => _storage.read(key: 'token');

  Future<bool> updateProfile({required String name, required String email}) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return false;
      final response = await _httpClient.put(
        Uri.parse(ApiConstants.me),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'email': email}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['user'] != null) {
          await _storage.write(key: 'user', value: jsonEncode(data['user']));
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _storeAuthData(Map<String, dynamic> data) async {
    await _storage.write(key: 'token', value: data['token']);
    await _storage.write(key: 'user', value: jsonEncode(data['user']));
  }

  Future<void> _clearAuthData() async {
    await _storage.deleteAll();
  }

  void dispose() {
    _httpClient.close();
  }
}