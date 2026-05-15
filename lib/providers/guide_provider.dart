import 'package:flutter/foundation.dart';

import '../services/guide_service.dart';

class GuideProvider with ChangeNotifier {
  final GuideService _service;

  bool isLoading = false;
  String? error;

  // ── Dashboard ──
  Map<String, dynamic> home = {};

  // ── Centers ──
  List<Map<String, dynamic>> centers = [];
  Map<String, dynamic> centerDetail = {};

  // ── Supervisors ──
  List<Map<String, dynamic>> supervisors = [];

  // ── Circles ──
  List<Map<String, dynamic>> circles = [];

  // ── Monthly Plans ──
  List<Map<String, dynamic>> monthlyPlans = [];

  // ── Visits ──
  List<Map<String, dynamic>> visits = [];
  Map<String, dynamic> visitDetail = {};
  /// Stores students for the current visit evaluation
  List<Map<String, dynamic>> visitStudents = [];

  // ── Training Needs ──
  List<Map<String, dynamic>> trainingNeeds = [];

  // ── Training Plan ──
  List<Map<String, dynamic>> trainingPlan = [];

  // ── Educational Supervisions ──
  List<Map<String, dynamic>> educationalSupervisions = [];

  // ── Recommendations ──
  List<Map<String, dynamic>> recommendations = [];

  // ── Reports ──
  Map<String, dynamic> reportsData = {};

  GuideProvider({GuideService? service}) : _service = service ?? GuideService();

  // ═══════════════════════════════════════════════════════════
  //  LOADERS
  // ═══════════════════════════════════════════════════════════

  Future<void> loadHome() => _run(() async {
        home = await _service.getHome();
      });

  Future<void> loadCenters() => _run(() async {
        centers = await _service.getCenters();
      });

  Future<void> loadCenterDetail(int id) => _run(() async {
        centerDetail = await _service.getCenter(id);
      });

  Future<void> loadSupervisors() => _run(() async {
        supervisors = await _service.getSupervisors();
      });

  Future<void> loadCircles() => _run(() async {
        circles = await _service.getCircles();
      });

  Future<void> loadMonthlyPlans() => _run(() async {
        monthlyPlans = await _service.getMonthlyPlans();
      });

  Future<void> loadVisits() => _run(() async {
        visits = await _service.getVisitSchedule();
      });

  Future<void> loadVisitDetail(int id) => _run(() async {
        visitDetail = await _service.getVisit(id);
      });

  Future<void> loadTrainingNeeds() => _run(() async {
        trainingNeeds = await _service.getTrainingNeeds();
      });

  Future<void> loadTrainingPlan() => _run(() async {
        trainingPlan = await _service.getTrainingPlan();
      });

  Future<void> loadEducationalSupervisions() => _run(() async {
        educationalSupervisions = await _service.getEducationalSupervisions();
      });

  Future<void> loadRecommendations() => _run(() async {
        recommendations = await _service.getRecommendations();
      });

  Future<void> loadReports() => _run(() async {
        reportsData = await _service.getReportsData();
      });

  // ═══════════════════════════════════════════════════════════
  //  ACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<void> approveMonthlyPlan(int planId) async {
    await _service.approveMonthlyPlan(planId);
    await loadMonthlyPlans();
  }

  Future<void> returnMonthlyPlan(int planId, String notes) async {
    await _service.returnMonthlyPlan(planId, notes);
    await loadMonthlyPlans();
  }

  Future<Map<String, dynamic>> createVisit(Map<String, dynamic> body) async {
    final result = await _service.createVisit(body);
    await loadVisits();
    return result;
  }

  Future<void> updateVisit(int id, Map<String, dynamic> body) async {
    await _service.updateVisit(id, body);
    await loadVisitDetail(id);
  }

  Future<void> saveVisitStudents(int id, List<Map<String, dynamic>> students) async {
    await _service.saveVisitStudents(id, students);
  }

  Future<void> submitVisit(int id) async {
    await _service.submitVisit(id);
    await loadVisitDetail(id);
    await loadVisits();
  }

  Future<void> approveVisit(int id) async {
    await _service.approveVisit(id);
    await loadVisitDetail(id);
    await loadVisits();
  }

  Future<void> createTrainingNeed(Map<String, dynamic> body) async {
    await _service.createTrainingNeed(body);
    await loadTrainingNeeds();
  }

  Future<void> createTrainingWorkshop(Map<String, dynamic> body) async {
    await _service.createTrainingWorkshop(body);
    await loadTrainingPlan();
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════

  Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      error = e.toString();
      debugPrint('GuideProvider error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
