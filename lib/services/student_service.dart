import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/student_model.dart';
import '../models/daily_task_model.dart';
import '../models/goal_model.dart';
import '../models/achievement_model.dart';

class StudentService {
  final _storage = const FlutterSecureStorage();
  final http.Client _httpClient;

  StudentService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<String?> _getToken() async => _storage.read(key: 'token');

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  List<dynamic> _extractItems(dynamic data) {
    if (data is Map && data.containsKey('data')) return data['data'];
    if (data is List) return data;
    return [];
  }

  Future<List<DailyTaskModel>> getDailyTasks() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.studentDailyTasks),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('tasks')) {
          final List<dynamic> tasks = data['tasks'] ?? [];
          return tasks.asMap().entries.map((entry) {
            final task = entry.value;
            return DailyTaskModel(
              id: task['id'] ?? entry.key,
              title: task['title'] ?? task['type'] ?? '',
              done: task['done'] ?? task['completed'] ?? false,
              description: task['description'],
              dueDate: task['due_date'] != null ? DateTime.parse(task['due_date']) : null,
            );
          }).toList();
        }
        return _extractItems(data).map((json) => DailyTaskModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل المهام اليومية: ${response.statusCode}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل المهام: $e');
    }
  }

  Future<List<GoalModel>> getGoals() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.studentGoals),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractItems(data).map((json) => GoalModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل الأهداف: ${response.statusCode}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الأهداف: $e');
    }
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> goalData) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.put(
        Uri.parse('${ApiConstants.studentGoals}/$goalId'),
        headers: _headers(token),
        body: jsonEncode(goalData),
      );

      if (response.statusCode != 200) {
        throw Exception('فشل تحديث الهدف: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحديث الهدف: $e');
    }
  }

  Future<List<AchievementModel>> getAchievements() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.studentAchievements),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractItems(data).map((json) => AchievementModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل الإنجازات: ${response.statusCode}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الإنجازات: $e');
    }
  }

  Future<StudentModel> getStudentProfile() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.me),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        return StudentModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('فشل تحميل الملف الشخصي: ${response.statusCode}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الملف الشخصي: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
