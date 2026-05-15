import 'package:flutter/foundation.dart';

import '../services/teacher_service.dart';

/// Maps a memorization performance double (0.0-1.0 from slider) to backend string enum.
String _performanceToEnum(double? value) {
  if (value == null) return 'acceptable';
  if (value >= 0.8) return 'excellent';
  if (value >= 0.6) return 'very_good';
  if (value >= 0.4) return 'good';
  if (value >= 0.2) return 'acceptable';
  return 'poor';
}

class TeacherProvider with ChangeNotifier {
  final TeacherService _service;

  bool isLoading = false;
  String? error;

  // ───── Dashboard ─────
  Map<String, dynamic> home = {};
  Map<String, dynamic> pendingActions = {};

  // ───── Circles ─────
  List<Map<String, dynamic>> circles = [];
  Map<String, dynamic>? selectedCircle;

  // ───── Students ─────
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> circleStudents = [];
  Map<String, dynamic>? selectedStudent;

  // ───── Daily Session ─────
  Map<String, dynamic>? todaySession;
  List<Map<String, dynamic>> sessionEntries = [];

  // ───── Risk & Intervention ─────
  List<Map<String, dynamic>> riskStudents = [];

  // ───── Evaluations & Tests ─────
  List<Map<String, dynamic>> weeklyEvaluations = [];
  List<Map<String, dynamic>> monthlyTests = [];

  TeacherProvider({TeacherService? service}) : _service = service ?? TeacherService();

  // ═══════════════════════════════════════════
  //  DASHBOARD
  // ═══════════════════════════════════════════

  Future<void> loadHome() async {
    await _run(() async {
      home = await _service.getTeacherHome();
      pendingActions = await _service.getPendingActions();
    });
  }

  // ═══════════════════════════════════════════
  //  CIRCLES
  // ═══════════════════════════════════════════

  Future<void> loadCircles() async {
    await _run(() async {
      circles = await _service.getCircles();
    });
  }

  Future<void> loadCircleDetail(int circleId) async {
    await _run(() async {
      selectedCircle = await _service.getCircleDetail(circleId);
    });
  }

  void selectCircle(Map<String, dynamic> circle) {
    selectedCircle = circle;
    notifyListeners();
  }

  int? get selectedCircleId {
    final id = selectedCircle?['id'];
    if (id is int) return id;
    if (id is num) return id.toInt();
    return int.tryParse('$id');
  }

  // ═══════════════════════════════════════════
  //  STUDENTS
  // ═══════════════════════════════════════════

  Future<void> loadAllStudents() async {
    await _run(() async {
      students = await _service.getStudents();
    });
  }

  Future<void> loadCircleStudents(int circleId) async {
    await _run(() async {
      circleStudents = await _service.getCircleStudents(circleId);
    });
  }

  void selectStudent(Map<String, dynamic> student) {
    selectedStudent = student;
    notifyListeners();
  }

  // ═══════════════════════════════════════════
  //  DAILY SESSION (The core "دفتر المتابعة")
  // ═══════════════════════════════════════════

  /// Load (or create) today's session for a circle and its student entries.
  Future<void> loadTodaySession(int circleId) async {
    await _run(() async {
      todaySession = await _service.getTodaySession(circleId);

      // Backend returns { session: {...entries: [...]}, students: [...] }
      final sessionData = todaySession;
      if (sessionData != null) {
        final session = sessionData['session'] as Map<String, dynamic>?;
        if (session != null) {
          final rawEntries = session['entries'];
          if (rawEntries != null && rawEntries is List && rawEntries.isNotEmpty) {
            sessionEntries = rawEntries
                .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
                .toList();
            notifyListeners();
            return;
          }
        }

        // No existing entries — get students list from response to build empty entries
        final rawStudents = sessionData['students'];
        if (rawStudents != null && rawStudents is List && rawStudents.isNotEmpty) {
          sessionEntries = rawStudents
              .map((s) => s is Map<String, dynamic> ? _buildEmptyEntry(s) : <String, dynamic>{})
              .toList();
          notifyListeners();
          return;
        }
      }

      // Fallback: load students from circles API
      await loadCircleStudents(circleId);
      sessionEntries = circleStudents.map((s) => _buildEmptyEntry(s)).toList();
    });
  }

  /// Open a new daily session explicitly.
  Future<void> openSession(int circleId) async {
    await _run(() async {
      todaySession = await _service.openTodaySession(circleId);
      notifyListeners();
    });
  }

  /// Update a specific student entry in the session.
  void updateStudentEntry(int index, Map<String, dynamic> updatedEntry) {
    if (index >= 0 && index < sessionEntries.length) {
      sessionEntries[index] = updatedEntry;
      notifyListeners();
    }
  }

  /// Save all session entries as draft.
  Future<bool> saveSessionAsDraft() async {
    if (todaySession == null) return false;

    // Get session ID from nested or flat structure
    final session = todaySession!['session'] as Map<String, dynamic>? ?? todaySession!;
    final sessionId = _toInt(session['id']);
    if (sessionId <= 0) return false;

    final entries = sessionEntries.map((e) {
      final entry = Map<String, dynamic>.from(e);
      // Remove display-only fields
      entry.remove('student_name');

      // Convert performance slider value (0.0-1.0 double) → backend string enum
      final perf = entry['memorization_performance'];
      if (perf is double || perf is int) {
        entry['memorization_performance'] = _performanceToEnum((perf as num).toDouble());
      }

      return entry;
    }).toList();

    try {
      await _service.submitSessionEntries(sessionId: sessionId, entries: entries);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Submit the session (save entries + finalize).
  Future<bool> submitSession() async {
    if (todaySession == null) return false;

    // First save entries
    final saved = await saveSessionAsDraft();
    if (!saved) return false;

    // Get session ID from nested or flat structure
    final session = todaySession!['session'] as Map<String, dynamic>? ?? todaySession!;
    final sessionId = _toInt(session['id']);
    if (sessionId <= 0) return false;

    // Then submit
    try {
      await _service.submitDailySession(sessionId);
      // Refresh dashboard in the background (fire-and-forget is fine for UX)
      loadHome();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════
  //  ATTENDANCE
  // ═══════════════════════════════════════════

  Future<bool> submitAttendance({
    required int circleId,
    required String date,
    required List<Map<String, dynamic>> entries,
    int? sessionId,
  }) async {
    try {
      await _service.submitAttendance(
        circleId: circleId,
        date: date,
        entries: entries,
        sessionId: sessionId,
      );
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════
  //  WEEKLY EVALUATIONS
  // ═══════════════════════════════════════════

  Future<void> loadWeeklyEvaluations() async {
    await _run(() async {
      weeklyEvaluations = await _service.getWeeklyEvaluations();
    });
  }

  Future<bool> saveWeeklyEvaluation(Map<String, dynamic> body) async {
    try {
      await _service.submitWeeklyEvaluation(body);
      await loadWeeklyEvaluations();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════
  //  MONTHLY TESTS
  // ═══════════════════════════════════════════

  Future<void> loadMonthlyTests() async {
    await _run(() async {
      monthlyTests = await _service.getMonthlyTests();
    });
  }

  Future<bool> saveTestResults(int testId, List<Map<String, dynamic>> results) async {
    try {
      await _service.saveTestResults(testId, results);
      await loadMonthlyTests();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createMonthlyTest(Map<String, dynamic> body) async {
    try {
      await _service.createMonthlyTest(body);
      await loadMonthlyTests();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════
  //  RISK STUDENTS & INTERVENTIONS
  // ═══════════════════════════════════════════

  Future<void> loadRiskStudents() async {
    await _run(() async {
      riskStudents = await _service.getRiskStudents();
    });
  }

  Future<bool> createRemedialPlan(Map<String, dynamic> body) async {
    try {
      await _service.createRemedialPlan(body);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createParentContactLog(Map<String, dynamic> body) async {
    try {
      await _service.createParentContactLog(body);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════

  /// Build an empty entry for a student, used when starting a new session.
  /// Field names match the DailyStudentEntry model's $fillable.
  Map<String, dynamic> _buildEmptyEntry(Map<String, dynamic> student) {
    return {
      'student_id': student['id'],
      'student_name': student['full_name'] ?? student['name'] ?? '',
      'attendance_status': 'present',
      'memorization_from_surah': null,
      'memorization_from_ayah': null,
      'memorization_to_surah': null,
      'memorization_to_ayah': null,
      'memorization_performance': null,
      'review_from_surah': null,
      'review_from_ayah': null,
      'review_to_surah': null,
      'review_to_ayah': null,
      'review_performance': null,
      'tajweed_observation': '',
      'tajweed_weakness': '',
      'notes': '',
      'weakness_flag': false,
      'parent_contacted': false,
    };
  }

  /// Safely convert a dynamic value to int.
  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  /// Clear any selected state (e.g. when navigating away).
  void clearSelection() {
    selectedCircle = null;
    selectedStudent = null;
    todaySession = null;
    sessionEntries = [];
    circleStudents = [];
    notifyListeners();
  }

  /// Clear error state.
  void clearError() {
    error = null;
    notifyListeners();
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
