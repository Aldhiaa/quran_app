import 'package:flutter/foundation.dart';

import '../services/supervisor_service.dart';

class SupervisorProvider with ChangeNotifier {
  final SupervisorService _service;

  bool isLoading = false;
  String? error;
  Map<String, dynamic> home = {};
  Map<String, dynamic> pendingApprovals = {};
  List<Map<String, dynamic>> centers = [];
  List<Map<String, dynamic>> attendanceAlerts = [];

  SupervisorProvider({SupervisorService? service}) : _service = service ?? SupervisorService();

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

  Future<void> loadAttendanceAlerts() async {
    await _run(() async {
      attendanceAlerts = await _service.getAttendanceAlerts();
    });
  }

  Future<void> returnMonthlyTest(int testId, String notes) async {
    await _service.returnMonthlyTest(testId, notes);
    await loadHome();
  }

  Future<void> approveMonthlyTest(int testId) async {
    await _service.approveMonthlyTest(testId);
    await loadHome();
  }

  Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

