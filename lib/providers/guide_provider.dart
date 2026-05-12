import 'package:flutter/foundation.dart';

import '../services/guide_service.dart';

class GuideProvider with ChangeNotifier {
  final GuideService _service;

  bool isLoading = false;
  String? error;
  Map<String, dynamic> home = {};
  List<Map<String, dynamic>> centers = [];
  List<Map<String, dynamic>> visits = [];
  List<Map<String, dynamic>> trainingNeeds = [];

  GuideProvider({GuideService? service}) : _service = service ?? GuideService();

  Future<void> loadHome() async {
    await _run(() async {
      home = await _service.getHome();
    });
  }

  Future<void> loadCenters() async {
    await _run(() async {
      centers = await _service.getCenters();
    });
  }

  Future<void> loadVisits() async {
    await _run(() async {
      visits = await _service.getVisitSchedule();
    });
  }

  Future<void> loadTrainingNeeds() async {
    await _run(() async {
      trainingNeeds = await _service.getTrainingNeeds();
    });
  }

  Future<void> returnMonthlyPlan(int planId, String notes) async {
    await _service.returnMonthlyPlan(planId, notes);
    await loadHome();
  }

  Future<void> approveMonthlyPlan(int planId) async {
    await _service.approveMonthlyPlan(planId);
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

