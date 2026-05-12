class TeacherEndpoints {
  const TeacherEndpoints._();

  static const home = '/mobile/teacher/home';
  static const circles = '/mobile/teacher/circles';
  static const today = '/mobile/teacher/today';
  static const pendingActions = '/mobile/teacher/pending-actions';
  static const openSession = '/mobile/teacher/daily-sessions/open';
  static const attendanceBulk = '/mobile/teacher/attendance/bulk';
  static const weeklyEvaluations = '/mobile/teacher/weekly-evaluations';
  static const monthlyTests = '/mobile/teacher/monthly-tests';
  static const riskStudents = '/mobile/teacher/risk-students';
  static const remedialPlans = '/mobile/teacher/remedial-plans';
  static const parentContactLogs = '/mobile/teacher/parent-contact-logs';

  static String circle(int id) => '/mobile/teacher/circles/$id';
  static String sessionEntriesBulk(int sessionId) => '/mobile/teacher/daily-sessions/$sessionId/entries/bulk';
  static String submitSession(int sessionId) => '/mobile/teacher/daily-sessions/$sessionId/submit';
  static String monthlyTestResultsBulk(int testId) => '/mobile/teacher/monthly-tests/$testId/results/bulk';
}

