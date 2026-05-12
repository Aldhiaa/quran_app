class StudentEndpoints {
  const StudentEndpoints._();

  static const dailyTasks = '/student/daily-tasks';
  static const goals = '/student/goals';
  static const achievements = '/student/achievements';
  static const summary = '/student/summary';
  static const plan = '/student/plan';
  static const homework = '/student/homework';
  static const teacherNotes = '/student/teacher-notes';

  static String updateGoal(String id) => '/student/goals/$id';
  static String homeworkStatus(int id) => '/student/homework/$id/status';
}

