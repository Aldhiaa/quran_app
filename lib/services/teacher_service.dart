import 'package:http/http.dart' as http;

import '../core/api/api_client.dart';
import '../core/api/endpoints/teacher_endpoints.dart';
import '../core/utils/response_utils.dart';

class TeacherService {
  final ApiClient _apiClient;

  TeacherService({http.Client? httpClient, ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(httpClient: httpClient);

  Future<Map<String, dynamic>> getDashboardStats() async {
    return getTeacherHome();
  }

  Future<Map<String, dynamic>> getTeacherSummary() async {
    return getTeacherHome();
  }

  Future<Map<String, dynamic>> getTeacherHome() async {
    return ResponseUtils.dataMap(await _apiClient.get(TeacherEndpoints.home));
  }

  Future<Map<String, dynamic>> getPendingActions() async {
    return ResponseUtils.dataMap(await _apiClient.get(TeacherEndpoints.pendingActions));
  }

  Future<List<Map<String, dynamic>>> getCircles() async {
    return ResponseUtils.list(await _apiClient.get(TeacherEndpoints.circles));
  }

  Future<Map<String, dynamic>> getCircleDetail(int circleId) async {
    return ResponseUtils.dataMap(await _apiClient.get(TeacherEndpoints.circle(circleId)));
  }

  Future<Map<String, dynamic>> getTodaySession(int circleId) async {
    return ResponseUtils.dataMap(
      await _apiClient.get(
        TeacherEndpoints.today,
        queryParameters: {'circle_id': circleId},
      ),
    );
  }

  Future<Map<String, dynamic>> openTodaySession(int circleId) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        TeacherEndpoints.openSession,
        body: {'circle_id': circleId},
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final circles = await getCircles();
    final students = <Map<String, dynamic>>[];
    for (final circle in circles) {
      final detail = await getCircleDetail(_asInt(circle['id']));
      final roster = detail['students'] ?? detail['roster'] ?? detail['active_students'];
      students.addAll(ResponseUtils.list(roster));
    }
    return students;
  }

  Future<List<Map<String, dynamic>>> getCircleStudents(int circleId) async {
    final detail = await getCircleDetail(circleId);
    final roster = detail['students'] ?? detail['roster'] ?? detail['active_students'];
    return ResponseUtils.list(roster);
  }

  Future<List<Map<String, dynamic>>> getMonthlyTests() async {
    return ResponseUtils.list(await _apiClient.get(TeacherEndpoints.monthlyTests));
  }

  Future<Map<String, dynamic>> createDailySession(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(TeacherEndpoints.openSession, body: body));
  }

  Future<Map<String, dynamic>> createMonthlyTest(Map<String, dynamic> body) async {
    // The current mobile backend exposes listing and result bulk entry; creation still exists on the generic API.
    return ResponseUtils.dataMap(await _apiClient.post('/monthly-tests', body: body));
  }

  Future<Map<String, dynamic>> saveTestResults(int testId, List<Map<String, dynamic>> results) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        TeacherEndpoints.monthlyTestResultsBulk(testId),
        body: {'results': results},
      ),
    );
  }

  Future<Map<String, dynamic>> submitAttendance({
    required int circleId,
    required String date,
    required List<Map<String, dynamic>> entries,
    int? sessionId,
  }) async {
    final effectiveSessionId = sessionId ?? _asInt((await openTodaySession(circleId))['id']);
    return ResponseUtils.dataMap(
      await _apiClient.post(
        TeacherEndpoints.attendanceBulk,
        body: {
          'session_id': effectiveSessionId,
          'attendance': entries,
        },
      ),
    );
  }

  Future<Map<String, dynamic>> submitSessionEntries({
    required int sessionId,
    required List<Map<String, dynamic>> entries,
  }) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        TeacherEndpoints.sessionEntriesBulk(sessionId),
        body: {'entries': entries},
      ),
    );
  }

  Future<Map<String, dynamic>> submitDailySession(int sessionId) async {
    return ResponseUtils.dataMap(await _apiClient.post(TeacherEndpoints.submitSession(sessionId)));
  }

  Future<Map<String, dynamic>> submitWeeklyEvaluation(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(TeacherEndpoints.weeklyEvaluations, body: body));
  }

  Future<List<Map<String, dynamic>>> getWeeklyEvaluations() async {
    return ResponseUtils.list(await _apiClient.get(TeacherEndpoints.weeklyEvaluations));
  }

  Future<Map<String, dynamic>> createHomework(Map<String, dynamic> body) async {
    // Backend route is expected in a later mobile iteration; keep generic payload compatible.
    return ResponseUtils.dataMap(await _apiClient.post('/homework', body: body));
  }

  Future<Map<String, dynamic>> createTeacherNote(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post('/teacher-notes', body: body));
  }

  Future<List<Map<String, dynamic>>> getRiskStudents() async {
    return ResponseUtils.list(await _apiClient.get(TeacherEndpoints.riskStudents));
  }

  Future<Map<String, dynamic>> createRemedialPlan(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(TeacherEndpoints.remedialPlans, body: body));
  }

  Future<Map<String, dynamic>> createParentContactLog(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(TeacherEndpoints.parentContactLogs, body: body));
  }

  Future<Map<String, dynamic>> getCirclesWithStudents() async {
    return {'circles': await getCircles(), 'students': await getStudents()};
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  void dispose() {
    _apiClient.dispose();
  }
}
