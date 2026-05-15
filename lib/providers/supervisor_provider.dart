import 'package:flutter/foundation.dart';

import '../services/supervisor_service.dart';

class SupervisorProvider with ChangeNotifier {
  final SupervisorService _service;

  SupervisorProvider({SupervisorService? service}) : _service = service ?? SupervisorService();

  // ── Generic State ──────────────────────────────────────────
  bool isLoading = false;
  String? error;

  // ── Dashboard ──────────────────────────────────────────────
  Map<String, dynamic> home = {};
  Map<String, dynamic> pendingApprovals = {};

  // ── Centers ────────────────────────────────────────────────
  List<Map<String, dynamic>> centers = [];
  Map<String, dynamic>? selectedCenter;

  // ── Teachers & Circles ─────────────────────────────────────
  List<Map<String, dynamic>> teachers = [];
  List<Map<String, dynamic>> circles = [];

  // ── Attendance Alerts ──────────────────────────────────────
  List<Map<String, dynamic>> attendanceAlerts = [];

  // ── Tasks ──────────────────────────────────────────────────
  List<Map<String, dynamic>> tasks = [];

  // ── Center Requests ────────────────────────────────────────
  List<Map<String, dynamic>> centerRequests = [];

  // ── Visits ─────────────────────────────────────────────────
  List<Map<String, dynamic>> visits = [];
  Map<String, dynamic>? selectedVisit;

  // ── Risk Cases ─────────────────────────────────────────────
  List<Map<String, dynamic>> riskCases = [];

  // ── Educational Supervisions ───────────────────────────────
  List<Map<String, dynamic>> educationalSupervisions = [];

  // ── Parent Contacts ────────────────────────────────────────
  List<Map<String, dynamic>> parentContacts = [];

  // ── Reports ────────────────────────────────────────────────
  List<Map<String, dynamic>> reports = [];

  // ═══════════════════════════════════════════════════════════
  //  HELPER
  // ═══════════════════════════════════════════════════════════

  Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      error = e.toString();
      debugPrint('SupervisorProvider error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  LOADERS
  // ═══════════════════════════════════════════════════════════

  Future<void> loadHome() async {
    await _run(() async {
      home = await _service.getHome();
      pendingApprovals = await _service.getPendingApprovals();
    });
  }

  Future<void> loadCenters() async {
    await _run(() async {
      centers = await _service.getCenters();
    });
  }

  Future<void> loadCenterDetail(int id) async {
    await _run(() async {
      selectedCenter = await _service.getCenter(id);
    });
  }

  Future<void> loadTeachers() async {
    await _run(() async {
      teachers = await _service.getTeachers();
    });
  }

  Future<void> loadCircles() async {
    await _run(() async {
      circles = await _service.getCircles();
    });
  }

  Future<void> loadAttendanceAlerts() async {
    await _run(() async {
      attendanceAlerts = await _service.getAttendanceAlerts();
    });
  }

  Future<void> loadTasks() async {
    await _run(() async {
      tasks = await _service.getTasks();
    });
  }

  Future<void> loadCenterRequests() async {
    await _run(() async {
      centerRequests = await _service.getCenterRequests();
    });
  }

  Future<void> loadVisits() async {
    await _run(() async {
      visits = await _service.getVisits();
    });
  }

  Future<void> loadVisitDetail(int id) async {
    await _run(() async {
      selectedVisit = await _service.getVisitDetail(id);
    });
  }

  Future<void> loadRiskCases() async {
    await _run(() async {
      riskCases = await _service.getRiskCases();
    });
  }

  Future<void> loadEducationalSupervisions() async {
    await _run(() async {
      educationalSupervisions = await _service.getEducationalSupervisions();
    });
  }

  Future<void> loadParentContacts() async {
    await _run(() async {
      parentContacts = await _service.getParentContacts();
    });
  }

  Future<void> loadReports({Map<String, String>? filters}) async {
    await _run(() async {
      reports = await _service.getReports(filters: filters);
    });
  }

  // ═══════════════════════════════════════════════════════════
  //  ACTIONS
  // ═══════════════════════════════════════════════════════════

  // ── Approvals ────────────────────────────────────────────

  Future<bool> approveMonthlyTest(int testId) {
    return _actionWithReload(() => _service.approveMonthlyTest(testId), loadHome);
  }

  Future<bool> returnMonthlyTest(int testId, String notes) {
    return _actionWithReload(() => _service.returnMonthlyTest(testId, notes), loadHome);
  }

  Future<bool> approveWeeklyEvaluation(int evaluationId) {
    return _actionWithReload(() => _service.approveWeeklyEvaluation(evaluationId), loadHome);
  }

  Future<bool> returnWeeklyEvaluation(int evaluationId, String notes) {
    return _actionWithReload(() => _service.returnWeeklyEvaluation(evaluationId, notes), loadHome);
  }

  Future<bool> approveMonthlyPlan(int planId) {
    return _actionWithReload(() => _service.approveMonthlyPlan(planId), loadHome);
  }

  Future<bool> returnMonthlyPlan(int planId, String notes) {
    return _actionWithReload(() => _service.returnMonthlyPlan(planId, notes), loadHome);
  }

  Future<bool> reviewSession(int sessionId, String status, {String? notes}) {
    return _actionWithReload(
      () => _service.reviewSession(sessionId: sessionId, status: status, reviewNotes: notes),
      loadHome,
    );
  }

  // ── Tasks ────────────────────────────────────────────────

  Future<bool> createTask(Map<String, dynamic> data) {
    return _actionWithReload(() => _service.createTask(data), loadTasks);
  }

  Future<bool> updateTaskStatus(int taskId, String status, {String? notes}) {
    return _actionWithReload(() => _service.updateTaskStatus(taskId, status, notes: notes), loadTasks);
  }

  // ── Center Requests ──────────────────────────────────────

  Future<bool> createCenterRequest(Map<String, dynamic> data) {
    return _actionWithReload(() => _service.createCenterRequest(data), loadCenterRequests);
  }

  Future<bool> approveCenterRequest(int requestId, {String? notes}) {
    return _actionWithReload(
      () => _service.approveCenterRequest(requestId, notes: notes),
      loadCenterRequests,
    );
  }

  // ── Visits ───────────────────────────────────────────────

  Future<bool> createVisit(Map<String, dynamic> data) {
    return _actionWithReload(() => _service.createVisit(data), loadVisits);
  }

  // ── Parent Contacts ──────────────────────────────────────

  Future<bool> createParentContact(Map<String, dynamic> data) {
    return _actionWithReload(() => _service.createParentContact(data), loadParentContacts);
  }

  // ═══════════════════════════════════════════════════════════
  //  GENERIC ACTION WRAPPER
  // ═══════════════════════════════════════════════════════════

  Future<bool> _actionWithReload(
    Future<Map<String, dynamic>> Function() action,
    Future<void> Function() reload,
  ) async {
    try {
      await action();
      await reload();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
