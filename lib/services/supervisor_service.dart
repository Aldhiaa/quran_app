import 'package:http/http.dart' as http;

import '../core/api/api_client.dart';
import '../core/api/endpoints/supervisor_endpoints.dart';
import '../core/utils/response_utils.dart';

class SupervisorService {
  final ApiClient _apiClient;

  SupervisorService({http.Client? httpClient, ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(httpClient: httpClient);

  Future<Map<String, dynamic>> getHome() async {
    return ResponseUtils.dataMap(await _apiClient.get(SupervisorEndpoints.home));
  }

  Future<Map<String, dynamic>> getSummary() async {
    return ResponseUtils.dataMap(await _apiClient.get(SupervisorEndpoints.summary));
  }

  Future<List<Map<String, dynamic>>> getCenters() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.centers));
  }

  Future<Map<String, dynamic>> getCenter(int id) async {
    return ResponseUtils.dataMap(await _apiClient.get(SupervisorEndpoints.center(id)));
  }

  Future<List<Map<String, dynamic>>> getTeachers() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.teachers));
  }

  Future<List<Map<String, dynamic>>> getCircles() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.circles));
  }

  Future<List<Map<String, dynamic>>> getAttendanceAlerts() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.attendanceAlerts));
  }

  Future<Map<String, dynamic>> getPendingApprovals() async {
    return ResponseUtils.dataMap(await _apiClient.get(SupervisorEndpoints.pendingApprovals));
  }

  Future<Map<String, dynamic>> reviewSession({
    required int sessionId,
    required String status,
    String? reviewNotes,
  }) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SupervisorEndpoints.reviewSession(sessionId),
        body: {'status': status, if (reviewNotes != null) 'review_notes': reviewNotes},
      ),
    );
  }

  Future<Map<String, dynamic>> approveWeeklyEvaluation(int evaluationId) async {
    return ResponseUtils.dataMap(await _apiClient.post(SupervisorEndpoints.approveEvaluation(evaluationId)));
  }

  Future<Map<String, dynamic>> returnWeeklyEvaluation(int evaluationId, String notes) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SupervisorEndpoints.returnEvaluation(evaluationId),
        body: {'review_notes': notes},
      ),
    );
  }

  Future<Map<String, dynamic>> approveMonthlyTest(int testId) async {
    return ResponseUtils.dataMap(await _apiClient.post(SupervisorEndpoints.approveTest(testId)));
  }

  Future<Map<String, dynamic>> returnMonthlyTest(int testId, String notes) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SupervisorEndpoints.returnTest(testId),
        body: {'review_notes': notes},
      ),
    );
  }

  Future<Map<String, dynamic>> approveMonthlyPlan(int planId) async {
    return ResponseUtils.dataMap(await _apiClient.post(SupervisorEndpoints.approvePlan(planId)));
  }

  Future<Map<String, dynamic>> returnMonthlyPlan(int planId, String notes) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SupervisorEndpoints.returnPlan(planId),
        body: {'review_notes': notes},
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.tasks));
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(SupervisorEndpoints.tasks, body: body));
  }

  Future<Map<String, dynamic>> updateTaskStatus(int taskId, String status, {String? notes}) async {
    return ResponseUtils.dataMap(
      await _apiClient.put(
        SupervisorEndpoints.taskStatus(taskId),
        body: {'status': status, if (notes != null) 'notes': notes},
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getCenterRequests() async {
    return ResponseUtils.list(await _apiClient.get(SupervisorEndpoints.centerRequests));
  }

  Future<Map<String, dynamic>> createCenterRequest(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(SupervisorEndpoints.centerRequests, body: body));
  }

  Future<Map<String, dynamic>> approveCenterRequest(int requestId, {String? notes}) async {
    return ResponseUtils.dataMap(
      await _apiClient.put(
        SupervisorEndpoints.approveCenterRequest(requestId),
        body: {if (notes != null) 'approval_notes': notes},
      ),
    );
  }
}

