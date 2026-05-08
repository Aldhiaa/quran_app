import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';

class TeacherService {
  final _storage = const FlutterSecureStorage();
  final http.Client _httpClient;

  TeacherService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> getDashboardStats() async {
    final data = await _authGet(ApiConstants.dashboardStats);
    return data;
  }

  Future<Map<String, dynamic>> getTeacherSummary() async {
    final data = await _authGet('${ApiConstants.baseUrl}/teacher/summary');
    return data;
  }

  Future<List<Map<String, dynamic>>> getCircles() async {
    final data = await _authGet('${ApiConstants.baseUrl}/circles');
    return _extractList(data);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final data = await _authGet('${ApiConstants.baseUrl}/students');
    return _extractList(data);
  }

  Future<List<Map<String, dynamic>>> getMonthlyTests() async {
    final data = await _authGet('${ApiConstants.baseUrl}/monthly-tests');
    return _extractList(data);
  }

  Future<Map<String, dynamic>> createDailySession(Map<String, dynamic> body) async {
    return await _authPost('${ApiConstants.baseUrl}/daily-sessions', body);
  }

  Future<Map<String, dynamic>> createMonthlyTest(Map<String, dynamic> body) async {
    return await _authPost('${ApiConstants.baseUrl}/monthly-tests', body);
  }

  Future<Map<String, dynamic>> saveTestResults(int testId, List<Map<String, dynamic>> results) async {
    return await _authPost('${ApiConstants.baseUrl}/monthly-tests/$testId/results', {'results': results});
  }

  Future<Map<String, dynamic>> getCirclesWithStudents() async {
    final circles = await getCircles();
    return {'circles': circles, 'students': await getStudents()};
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<dynamic> _authGet(String url) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) return jsonDecode(response.body);
      final msg = jsonDecode(response.body)['message'] ?? 'فشل الطلب: ${response.statusCode}';
      throw Exception(msg);
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    }
  }

  Future<Map<String, dynamic>> _authPost(String url, Map<String, dynamic> body) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      final msg = jsonDecode(response.body)['message'] ?? 'فشل الطلب: ${response.statusCode}';
      throw Exception(msg);
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
