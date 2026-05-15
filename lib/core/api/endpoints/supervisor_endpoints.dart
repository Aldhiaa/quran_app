class SupervisorEndpoints {
  const SupervisorEndpoints._();

  static const home = '/mobile/supervisor/home';
  static const centers = '/mobile/supervisor/centers';
  static const summary = '/mobile/supervisor/summary';
  static const teachers = '/mobile/supervisor/teachers';
  static const circles = '/mobile/supervisor/circles';
  static const attendanceAlerts = '/mobile/supervisor/attendance-alerts';
  static const pendingApprovals = '/mobile/supervisor/pending-approvals';
  static const tasks = '/mobile/supervisor/tasks';
  static const centerRequests = '/mobile/supervisor/center-requests';
  static const visits = '/mobile/supervisor/visits';
  static const riskCases = '/mobile/supervisor/risk-cases';
  static const educationalSupervisions = '/mobile/supervisor/educational-supervisions';
  static const parentContacts = '/mobile/supervisor/parent-contacts';
  static const reports = '/mobile/supervisor/reports';

  static String center(int id) => '/mobile/supervisor/centers/$id';
  static String reviewSession(int sessionId) => '/mobile/supervisor/daily-sessions/$sessionId/review';
  static String approveEvaluation(int evaluationId) => '/mobile/supervisor/weekly-evaluations/$evaluationId/approve';
  static String returnEvaluation(int evaluationId) => '/mobile/supervisor/weekly-evaluations/$evaluationId/return';
  static String approveTest(int testId) => '/mobile/supervisor/monthly-tests/$testId/approve';
  static String returnTest(int testId) => '/mobile/supervisor/monthly-tests/$testId/return';
  static String approvePlan(int planId) => '/mobile/supervisor/monthly-plans/$planId/approve';
  static String returnPlan(int planId) => '/mobile/supervisor/monthly-plans/$planId/return';
  static String taskStatus(int taskId) => '/mobile/supervisor/tasks/$taskId/status';
  static String approveCenterRequest(int requestId) => '/mobile/supervisor/center-requests/$requestId/approve';
  static String visitDetail(int visitId) => '/mobile/supervisor/visits/$visitId';
}
