import 'package:flutter/foundation.dart';

import '../services/teacher_service.dart';

class TeacherProvider with ChangeNotifier {
  final TeacherService _service;

  bool isLoading = false;
  String? error;
  Map<String, dynamic> home = {};
  List<Map<String, dynamic>> circles = [];
  List<Map<String, dynamic>> riskStudents = [];
  Map<String, dynamic> pendingActions = {};

  TeacherProvider({TeacherService? service}) : _service = service ?? TeacherService();

  Future<void> loadHome() async {
    await _run(() async {
      home = await _service.getTeacherHome();
      pendingActions = await _service.getPendingActions();
    });
  }

  Future<void> loadCircles() async {
    await _run(() async {
      circles = await _service.getCircles();
    });
  }

  Future<Map<String, dynamic>> openTodaySession(int circleId) {
    return _service.openTodaySession(circleId);
  }

  Future<void> loadRiskStudents() async {
    await _run(() async {
      riskStudents = await _service.getRiskStudents();
    });
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

