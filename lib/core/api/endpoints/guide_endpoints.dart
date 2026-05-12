class GuideEndpoints {
  const GuideEndpoints._();

  static const home = '/mobile/guide/home';
  static const centers = '/mobile/guide/centers';
  static const summary = '/mobile/guide/summary';
  static const supervisors = '/mobile/guide/supervisors';
  static const circles = '/mobile/guide/circles';
  static const monthlyPlans = '/mobile/guide/monthly-plans';
  static const visitSchedule = '/mobile/guide/visits/schedule';
  static const visits = '/mobile/guide/visits';
  static const trainingNeeds = '/mobile/guide/training-needs';
  static const trainingPlan = '/mobile/guide/training-plan';

  static String center(int id) => '/mobile/guide/centers/$id';
  static String approvePlan(int planId) => '/mobile/guide/monthly-plans/$planId/approve';
  static String returnPlan(int planId) => '/mobile/guide/monthly-plans/$planId/return';
  static String visit(int visitId) => '/mobile/guide/visits/$visitId';
  static String visitStudentsBulk(int visitId) => '/mobile/guide/visits/$visitId/students/bulk';
  static String submitVisit(int visitId) => '/mobile/guide/visits/$visitId/submit';
  static String approveVisit(int visitId) => '/mobile/guide/visits/$visitId/approve';
}

