class ApiConstants {
  static const baseUrl = 'https://baherit.tech/api/v1';

  // Auth endpoints
  static const login = '$baseUrl/auth/login';
  static const logout = '$baseUrl/auth/logout';
  static const me = '$baseUrl/auth/me';
  static const token = '$baseUrl/auth/token';
  static const revokeToken = '$baseUrl/auth/token/revoke';

  // Student endpoints
  static const studentDailyTasks = '$baseUrl/student/daily-tasks';
  static const studentGoals = '$baseUrl/student/goals';
  static const studentAchievements = '$baseUrl/student/achievements';

  // Communication endpoints
  static const messages = '$baseUrl/messages';
  static const announcements = '$baseUrl/announcements';
  static const unreadCountMessages = '$baseUrl/messages-unread-count';
  static const unreadCountNotifications = '$baseUrl/notifications/unread-count';

  // Notification endpoints
  static const notifications = '$baseUrl/notifications';
  static const markNotificationRead = '$baseUrl/notifications/';
  static const markAllNotificationsRead = '$baseUrl/notifications/read-all';

  // Dashboard endpoints
  static const dashboardStats = '$baseUrl/dashboard/stats';
  static const teacherSummary = '$baseUrl/teacher/summary';
  static const studentSummary = '$baseUrl/student/summary';

  // Circles & students
  static const circles = '$baseUrl/circles';
  static const students = '$baseUrl/students';

  // Daily sessions
  static const dailySessions = '$baseUrl/daily-sessions';

  // Attendance
  static const attendanceBulk = '$baseUrl/attendance/bulk';

  // Weekly evaluation
  static const weeklyEvaluations = '$baseUrl/weekly-evaluations';

  // Monthly tests / grades
  static const monthlyTests = '$baseUrl/monthly-tests';

  // Homework
  static const homework = '$baseUrl/homework';
  static const studentHomework = '$baseUrl/student/homework';

  // Teacher notes
  static const teacherNotes = '$baseUrl/teacher-notes';
  static const studentTeacherNotes = '$baseUrl/student/teacher-notes';

  // Plan
  static const studentPlan = '$baseUrl/student/plan';
}