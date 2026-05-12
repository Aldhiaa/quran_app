import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quran_mobile_ui/core/app_theme.dart';
import 'package:quran_mobile_ui/providers/auth_provider.dart';
import 'package:quran_mobile_ui/providers/guide_provider.dart';
import 'package:quran_mobile_ui/providers/supervisor_provider.dart';
import 'package:quran_mobile_ui/providers/sync_provider.dart';
import 'package:quran_mobile_ui/providers/teacher_provider.dart';
import 'package:quran_mobile_ui/services/auth_service.dart';
import 'package:quran_mobile_ui/services/student_service.dart';
import 'package:quran_mobile_ui/services/communication_service.dart';
import 'package:quran_mobile_ui/services/teacher_service.dart';
import 'package:quran_mobile_ui/services/guide_service.dart';
import 'package:quran_mobile_ui/services/supervisor_service.dart';
import 'package:quran_mobile_ui/services/sync_service.dart';
import 'package:quran_mobile_ui/screens/auth/login_screen.dart';
import 'package:quran_mobile_ui/screens/common/splash_screen.dart';
import 'package:quran_mobile_ui/screens/common/teacher_shell.dart';
import 'package:quran_mobile_ui/screens/common/student_shell.dart';
import 'package:quran_mobile_ui/screens/common/supervisor_shell.dart';
import 'package:quran_mobile_ui/screens/common/guide_shell.dart';
import 'package:quran_mobile_ui/screens/common/screen_catalog_screen.dart';
import 'package:quran_mobile_ui/screens/common/communication_hub_screen.dart';
import 'package:quran_mobile_ui/screens/common/announcements_screen.dart';
import 'package:quran_mobile_ui/screens/common/groups_screen.dart';
import 'package:quran_mobile_ui/screens/common/private_messages_screen.dart';
import 'package:quran_mobile_ui/screens/common/notifications_screen.dart';
import 'package:quran_mobile_ui/screens/student/student_dashboard_screen.dart';
import 'package:quran_mobile_ui/screens/student/daily_tasks_screen.dart';
import 'package:quran_mobile_ui/screens/student/student_progress_screen.dart';
import 'package:quran_mobile_ui/screens/student/review_screen.dart';
import 'package:quran_mobile_ui/screens/student/student_results_screen.dart';
import 'package:quran_mobile_ui/screens/student/attendance_screen.dart';
import 'package:quran_mobile_ui/screens/student/goals_screen.dart';
import 'package:quran_mobile_ui/screens/student/memorization_file_screen.dart';
import 'package:quran_mobile_ui/screens/student/achievements_screen.dart';
import 'package:quran_mobile_ui/screens/student/my_plan_screen.dart';
import 'package:quran_mobile_ui/screens/student/homework_screen.dart';
import 'package:quran_mobile_ui/screens/student/teacher_notes_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/teacher_dashboard_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/halaqat_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/students_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/student_detail_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/daily_followup_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/daily_report_entry_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/weekly_evaluation_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/monthly_exams_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/monthly_exam_create_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/exam_results_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/exam_result_detail_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/grades_entry_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/reports_center_screen.dart';
import 'package:quran_mobile_ui/screens/teacher/attendance_entry_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_dashboard_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_centers_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_center_detail_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_teachers_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_circles_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_attendance_alerts_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_visits_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_visit_form_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_educational_supervision_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_weekly_review_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_monthly_approval_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_risk_cases_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_parent_communication_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_reports_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_tasks_screen.dart';
import 'package:quran_mobile_ui/screens/supervisor/supervisor_requests_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_dashboard_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_centers_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_supervisors_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_circles_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_visits_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_visit_form_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_plans_review_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_educational_supervision_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_model_circle_evaluation_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_training_needs_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_training_plan_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_recommendations_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_monthly_approval_screen.dart';
import 'package:quran_mobile_ui/screens/guide/guide_reports_screen.dart';
import 'package:quran_mobile_ui/screens/settings/app_settings_screen.dart';
import 'package:quran_mobile_ui/screens/settings/profile_screen.dart';
import 'package:quran_mobile_ui/screens/settings/support_screen.dart';
import 'package:quran_mobile_ui/screens/settings/about_screen.dart';
import 'package:quran_mobile_ui/screens/settings/role_switch_screen.dart';

void main() {
  final studentService = StudentService();
  final communicationService = CommunicationService();
  final teacherService = TeacherService();
  final supervisorService = SupervisorService();
  final guideService = GuideService();
  final syncService = SyncService();
  final authService = AuthService();

  runApp(QuranApp(
    authService: authService,
    studentService: studentService,
    communicationService: communicationService,
    teacherService: teacherService,
    supervisorService: supervisorService,
    guideService: guideService,
    syncService: syncService,
  ));
}

class QuranApp extends StatelessWidget {
  final AuthService authService;
  final StudentService studentService;
  final CommunicationService communicationService;
  final TeacherService teacherService;
  final SupervisorService supervisorService;
  final GuideService guideService;
  final SyncService syncService;

  const QuranApp({
    super.key,
    required this.authService,
    required this.studentService,
    required this.communicationService,
    required this.teacherService,
    required this.supervisorService,
    required this.guideService,
    required this.syncService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authService: authService,
            studentService: studentService,
            communicationService: communicationService,
          ),
        ),
        ChangeNotifierProvider<TeacherProvider>(
          create: (_) => TeacherProvider(service: teacherService),
        ),
        ChangeNotifierProvider<SupervisorProvider>(
          create: (_) => SupervisorProvider(service: supervisorService),
        ),
        ChangeNotifierProvider<GuideProvider>(
          create: (_) => GuideProvider(service: guideService),
        ),
        ChangeNotifierProvider<SyncProvider>(
          create: (_) => SyncProvider(service: syncService),
        ),
        Provider<StudentService>.value(value: studentService),
        Provider<CommunicationService>.value(value: communicationService),
        Provider<TeacherService>.value(value: teacherService),
        Provider<SupervisorService>.value(value: supervisorService),
        Provider<GuideService>.value(value: guideService),
        Provider<SyncService>.value(value: syncService),
      ],
      child: MaterialApp(
        title: 'نظام المنارة',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildAppTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          // Role homes
          '/teacher/home': (context) => const TeacherShell(),
          '/student/home': (context) => const StudentShell(),
          '/supervisor/home': (context) => const SupervisorShell(),
          '/guide/home': (context) => const GuideShell(),
          // Catalog
          '/catalog': (context) => const ScreenCatalogScreen(),
          // Common
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
          '/student/plan': (context) => const MyPlanScreen(),
          '/student/homework': (context) => const HomeworkScreen(),
          '/student/teacher-notes': (context) => const TeacherNotesScreen(),
          // Teacher
          '/teacher/dashboard': (context) => const TeacherDashboardScreen(),
          '/teacher/halaqat': (context) => const HalaqatScreen(),
          '/teacher/students': (context) => const StudentsScreen(),
          '/teacher/student-detail': (context) => const StudentDetailScreen(),
          '/teacher/daily-followup': (context) => const DailyFollowupScreen(),
          '/teacher/daily-report-entry': (context) => const DailyReportEntryScreen(),
          '/teacher/attendance-entry': (context) => const AttendanceEntryScreen(),
          '/teacher/weekly-evaluation': (context) => const WeeklyEvaluationScreen(),
          '/teacher/monthly-exams': (context) => const MonthlyExamsScreen(),
          '/teacher/monthly-exam-create': (context) => const MonthlyExamCreateScreen(),
          '/teacher/exam-results': (context) => const ExamResultsScreen(),
          '/teacher/exam-result-detail': (context) => const ExamResultDetailScreen(),
          '/teacher/grades-entry': (context) => const GradesEntryScreen(),
          '/teacher/reports-center': (context) => const ReportsCenterScreen(),
          // Supervisor
          '/supervisor/dashboard': (context) => const SupervisorDashboardScreen(),
          '/supervisor/centers': (context) => const SupervisorCentersScreen(),
          '/supervisor/center-detail': (context) => const SupervisorCenterDetailScreen(),
          '/supervisor/teachers': (context) => const SupervisorTeachersScreen(),
          '/supervisor/circles': (context) => const SupervisorCirclesScreen(),
          '/supervisor/attendance-alerts': (context) => const SupervisorAttendanceAlertsScreen(),
          '/supervisor/visits': (context) => const SupervisorVisitsScreen(),
          '/supervisor/visits/create': (context) => const SupervisorVisitFormScreen(),
          '/supervisor/educational-supervision': (context) => const SupervisorEducationalSupervisionScreen(),
          '/supervisor/weekly-review': (context) => const SupervisorWeeklyReviewScreen(),
          '/supervisor/monthly-approval': (context) => const SupervisorMonthlyApprovalScreen(),
          '/supervisor/student-risk-cases': (context) => const SupervisorRiskCasesScreen(),
          '/supervisor/parent-communication': (context) => const SupervisorParentCommunicationScreen(),
          '/supervisor/reports': (context) => const SupervisorReportsScreen(),
          '/supervisor/tasks': (context) => const SupervisorTasksScreen(),
          '/supervisor/requests': (context) => const SupervisorRequestsScreen(),
          // Guide
          '/guide/dashboard': (context) => const GuideDashboardScreen(),
          '/guide/centers': (context) => const GuideCentersScreen(),
          '/guide/supervisors': (context) => const GuideSupervisorsScreen(),
          '/guide/circles': (context) => const GuideCirclesScreen(),
          '/guide/visits': (context) => const GuideVisitsScreen(),
          '/guide/visits/create': (context) => const GuideVisitFormScreen(),
          '/guide/plans-review': (context) => const GuidePlansReviewScreen(),
          '/guide/educational-supervision': (context) => const GuideEducationalSupervisionScreen(),
          '/guide/model-circle-evaluation': (context) => const GuideModelCircleEvaluationScreen(),
          '/guide/training-needs': (context) => const GuideTrainingNeedsScreen(),
          '/guide/training-plan': (context) => const GuideTrainingPlanScreen(),
          '/guide/recommendations': (context) => const GuideRecommendationsScreen(),
          '/guide/monthly-tests': (context) => const GuideMonthlyApprovalScreen(),
          '/guide/reports': (context) => const GuideReportsScreen(),
          // Settings
          '/settings/app': (context) => const AppSettingsScreen(),
          '/settings/profile': (context) => const ProfileScreen(),
          '/settings/support': (context) => const SupportScreen(),
          '/settings/about': (context) => const AboutScreen(),
          '/settings/role-switch': (context) => const RoleSwitchScreen(),
        },
      ),
    );
  }
}
