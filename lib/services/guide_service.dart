import 'package:http/http.dart' as http;

import '../core/api/api_client.dart';
import '../core/api/endpoints/guide_endpoints.dart';
import '../core/utils/response_utils.dart';

class GuideService {
  final ApiClient _apiClient;

  GuideService({http.Client? httpClient, ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(httpClient: httpClient);

  Future<Map<String, dynamic>> getHome() async {
    return ResponseUtils.dataMap(await _apiClient.get(GuideEndpoints.home));
  }

  Future<Map<String, dynamic>> getSummary() async {
    return ResponseUtils.dataMap(await _apiClient.get(GuideEndpoints.summary));
  }

  Future<List<Map<String, dynamic>>> getCenters() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.centers));
  }

  Future<Map<String, dynamic>> getCenter(int id) async {
    return ResponseUtils.dataMap(await _apiClient.get(GuideEndpoints.center(id)));
  }

  Future<List<Map<String, dynamic>>> getSupervisors() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.supervisors));
  }

  Future<List<Map<String, dynamic>>> getCircles() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.circles));
  }

  Future<List<Map<String, dynamic>>> getMonthlyPlans() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.monthlyPlans));
  }

  Future<Map<String, dynamic>> approveMonthlyPlan(int planId) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.approvePlan(planId)));
  }

  Future<Map<String, dynamic>> returnMonthlyPlan(int planId, String notes) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        GuideEndpoints.returnPlan(planId),
        body: {'review_notes': notes},
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getVisitSchedule() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.visitSchedule));
  }

  Future<Map<String, dynamic>> createVisit(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.visits, body: body));
  }

  Future<Map<String, dynamic>> getVisit(int id) async {
    return ResponseUtils.dataMap(await _apiClient.get(GuideEndpoints.visit(id)));
  }

  Future<Map<String, dynamic>> updateVisit(int id, Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.put(GuideEndpoints.visit(id), body: body));
  }

  Future<Map<String, dynamic>> saveVisitStudents(int id, List<Map<String, dynamic>> students) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        GuideEndpoints.visitStudentsBulk(id),
        body: {'students': students},
      ),
    );
  }

  Future<Map<String, dynamic>> submitVisit(int id) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.submitVisit(id)));
  }

  Future<Map<String, dynamic>> approveVisit(int id) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.approveVisit(id)));
  }

  Future<List<Map<String, dynamic>>> getTrainingNeeds() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.trainingNeeds));
  }

  Future<Map<String, dynamic>> createTrainingNeed(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.trainingNeeds, body: body));
  }

  Future<List<Map<String, dynamic>>> getTrainingPlan() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.trainingPlan));
  }

  Future<Map<String, dynamic>> createTrainingWorkshop(Map<String, dynamic> body) async {
    return ResponseUtils.dataMap(await _apiClient.post(GuideEndpoints.trainingPlan, body: body));
  }

  Future<List<Map<String, dynamic>>> getEducationalSupervisions() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.educationalSupervisions));
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    return ResponseUtils.list(await _apiClient.get(GuideEndpoints.recommendations));
  }

  Future<Map<String, dynamic>> getReportsData() async {
    return ResponseUtils.dataMap(await _apiClient.get(GuideEndpoints.reports));
  }
}

