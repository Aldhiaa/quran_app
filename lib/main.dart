import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'lib/providers/auth_provider.dart';
import 'lib/services/auth_service.dart';
import 'lib/services/student_service.dart';
import 'lib/services/communication_service.dart';
import 'lib/services/teacher_service.dart';
import 'lib/screens/auth/login_screen.dart';
import 'lib/screens/common/screen_catalog_screen.dart';
import 'lib/screens/common/communication_hub_screen.dart';
import 'lib/screens/common/announcements_screen.dart';
import 'lib/screens/common/groups_screen.dart';
import 'lib/screens/common/private_messages_screen.dart';
import 'lib/screens/common/notifications_screen.dart';
import 'lib/screens/student/student_dashboard_screen.dart';
import 'lib/screens/student/daily_tasks_screen.dart';
import 'lib/screens/student/student_progress_screen.dart';
import 'lib/screens/student/review_screen.dart';
import 'lib/screens/student/student_results_screen.dart';
import 'lib/screens/student/attendance_screen.dart';
import 'lib/screens/student/goals_screen.dart';
import 'lib/screens/student/memorization_file_screen.dart';
import 'lib/screens/student/achievements_screen.dart';
import 'lib/screens/teacher/teacher_dashboard_screen.dart';
import 'lib/screens/teacher/halaqat_screen.dart';
import 'lib/screens/teacher/students_screen.dart';
import 'lib/screens/teacher/student_detail_screen.dart';
import 'lib/screens/teacher/daily_followup_screen.dart';
import 'lib/screens/teacher/daily_report_entry_screen.dart';
import 'lib/screens/teacher/weekly_evaluation_screen.dart';
import 'lib/screens/teacher/monthly_exams_screen.dart';
import 'lib/screens/teacher/monthly_exam_create_screen.dart';
import 'lib/screens/teacher/exam_results_screen.dart';
import 'lib/screens/teacher/exam_result_detail_screen.dart';
import 'lib/screens/teacher/grades_entry_screen.dart';
import 'lib/screens/teacher/reports_center_screen.dart';
import 'lib/screens/settings/app_settings_screen.dart';
import 'lib/screens/settings/profile_screen.dart';
import 'lib/screens/settings/support_screen.dart';
import 'lib/screens/settings/about_screen.dart';
import 'lib/screens/settings/role_switch_screen.dart';

void main() {
  final studentService = StudentService();
  final communicationService = CommunicationService();
  final teacherService = TeacherService();
  final authService = AuthService();

  runApp(QuranApp(
    authService: authService,
    studentService: studentService,
    communicationService: communicationService,
    teacherService: teacherService,
  ));
}

class QuranApp extends StatelessWidget {
  final AuthService authService;
  final StudentService studentService;
  final CommunicationService communicationService;
  final TeacherService teacherService;

  const QuranApp({
    super.key,
    required this.authService,
    required this.studentService,
    required this.communicationService,
    required this.teacherService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
            studentService: studentService,
            communicationService: communicationService,
          )..checkAuthStatus(),
        ),
        Provider<StudentService>.value(value: studentService),
        Provider<CommunicationService>.value(value: communicationService),
        Provider<TeacherService>.value(value: teacherService),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'تعليم القرآن الكريم',
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: authProvider.isAuthenticated
                ? const ScreenCatalogScreen()
                : const LoginScreen(),
            routes: {
              // Auth
              '/login': (context) => const LoginScreen(),
              // Common
              '/catalog': (context) => const ScreenCatalogScreen(),
              '/common/communication': (context) => const CommunicationHubScreen(),
              '/common/announcements': (context) => const AnnouncementsScreen(),
              '/common/groups': (context) => const GroupsScreen(),
              '/common/private-messages': (context) => const PrivateMessagesScreen(),
              '/common/notifications': (context) => const NotificationsScreen(),
              // Student
              '/student/dashboard': (context) => const StudentDashboardScreen(),
              '/student/daily-tasks': (context) => const DailyTasksScreen(),
              '/student/progress': (context) => const StudentProgressScreen(),
              '/student/review': (context) => const ReviewScreen(),
              '/student/results': (context) => const StudentResultsScreen(),
              '/student/attendance': (context) => const AttendanceScreen(),
              '/student/goals': (context) => const GoalsScreen(),
              '/student/memorization-file': (context) => const MemorizationFileScreen(),
              '/student/achievements': (context) => const AchievementsScreen(),
              // Teacher
              '/teacher/dashboard': (context) => const TeacherDashboardScreen(),
              '/teacher/halaqat': (context) => const HalaqatScreen(),
              '/teacher/students': (context) => const StudentsScreen(),
              '/teacher/student-detail': (context) => const StudentDetailScreen(),
              '/teacher/daily-followup': (context) => const DailyFollowupScreen(),
              '/teacher/daily-report-entry': (context) => const DailyReportEntryScreen(),
              '/teacher/weekly-evaluation': (context) => const WeeklyEvaluationScreen(),
              '/teacher/monthly-exams': (context) => const MonthlyExamsScreen(),
              '/teacher/monthly-exam-create': (context) => const MonthlyExamCreateScreen(),
              '/teacher/exam-results': (context) => const ExamResultsScreen(),
              '/teacher/exam-result-detail': (context) => const ExamResultDetailScreen(),
              '/teacher/grades-entry': (context) => const GradesEntryScreen(),
              '/teacher/reports-center': (context) => const ReportsCenterScreen(),
              // Settings
              '/settings/app': (context) => const AppSettingsScreen(),
              '/settings/profile': (context) => const ProfileScreen(),
              '/settings/support': (context) => const SupportScreen(),
              '/settings/about': (context) => const AboutScreen(),
              '/settings/role-switch': (context) => const RoleSwitchScreen(),
            },
          );
        },
      ),
    );
  }
}
