import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TeacherProvider>().loadHome();
    });
  }

  Future<void> _refresh() async {
    await context.read<TeacherProvider>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final teacher = context.watch<TeacherProvider>();
    final home = teacher.home;
    final pending = teacher.pendingActions;
    final isLoading = teacher.isLoading;

    // Extract KPIs from home data — matching backend getHomeDashboard response keys
    final circlesCount = home['circles_count'] ??
        (home['today_circles'] is List ? (home['today_circles'] as List).length : 0);

    final studentsCount = home['students_count'] ?? '—';

    final todayPresent = home['today_present_count'] ?? '—';

    final attendanceRate = home['attendance_rate']?.toString() ?? '—';

    final pendingReports = home['pending_daily_reports'] ?? pending['missing_daily_reports'] ?? 0;
    final pendingEvaluations = pending['pending_weekly_evaluations'] ?? 0;
    final pendingTests = pending['pending_monthly_tests'] ??
        (home['upcoming_monthly_tests'] is List ? (home['upcoming_monthly_tests'] as List).length : 0);

    // Today's session info — backend returns a DailySession model instance
    final todaySession = home['today_session'] as Map<String, dynamic>?;
    String sessionCircleName = 'حلقة اليوم';
    int sessionPresent = 0;
    int sessionTotal = 0;
    double sessionProgress = 0.0;
    String sessionTime = '';

    if (todaySession != null) {
      sessionCircleName = todaySession['circle_name'] ??
          (todaySession['circle'] is Map ? (todaySession['circle'] as Map)['name'] as String? : null) ??
          'حلقة اليوم';
      final entries = todaySession['entries'];
      if (entries is List) {
        sessionTotal = entries.length;
        sessionPresent = entries.where((e) =>
            e is Map && e['attendance_status'] == 'present').length;
      }
      sessionProgress = sessionTotal > 0 ? sessionPresent / sessionTotal : 0.0;
    }

    return GreenHeaderScaffold(
      title: 'لوحة المعلم',
      showBack: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/common/notifications'),
        ),
      ],
      headerExtra: RoleDashboardHeader(
        name: auth.user?.name ?? 'الأستاذ',
        role: 'معلم حلقة',
        onTap: () => Navigator.pushNamed(context, '/settings/profile'),
      ),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            if (teacher.error != null) ...[
              AppCard(
                color: AppColors.danger.withValues(alpha: .06),
                child: Text(
                  teacher.error!,
                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // KPIs
            KpiGrid(items: [
              KpiCard(
                label: 'الحلقات',
                value: '$circlesCount',
                icon: Icons.menu_book_rounded,
                color: AppColors.primary,
              ),
              KpiCard(
                label: 'الطلاب',
                value: '$studentsCount',
                icon: Icons.groups_rounded,
                color: AppColors.info,
              ),
              KpiCard(
                label: 'الحضور اليوم',
                value: '$todayPresent',
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
                sub: 'نسبة $attendanceRate',
              ),
              KpiCard(
                label: 'الإختبارات',
                value: '$pendingTests',
                icon: Icons.assignment_turned_in_rounded,
                color: AppColors.accentGold,
              ),
            ]),
            const SizedBox(height: 14),

            // Today's Session Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('جلسة اليوم', style: TextStyle(fontWeight: FontWeight.w800)),
                      Spacer(),
                      StatusBadge(
                        text: 'جارية',
                        kind: BadgeKind.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    ProgressRing(
                      value: sessionProgress,
                      size: 72,
                      strokeWidth: 8,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sessionCircleName,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('$sessionPresent / $sessionTotal حاضر',
                              style: const TextStyle(color: AppColors.muted)),
                          const SizedBox(height: 4),
                          Text(sessionTime,
                              style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.fact_check_outlined),
                        label: const Text('متابعة'),
                        onPressed: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        label: const Text('إنهاء الجلسة'),
                        onPressed: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quick Actions
            const AppSectionTitle(title: 'إجراءات سريعة'),
            const SizedBox(height: 10),
            QuickActionGrid(actions: [
              QuickAction(
                label: 'تسجيل الحضور',
                icon: Icons.how_to_reg_rounded,
                color: AppColors.primary,
                route: '/teacher/attendance-entry',
              ),
              QuickAction(
                label: 'دفتر المتابعة',
                icon: Icons.menu_book_rounded,
                color: AppColors.info,
                route: '/teacher/daily-followup',
              ),
              QuickAction(
                label: 'التقييم الأسبوعي',
                icon: Icons.star_rate_rounded,
                color: AppColors.accentGold,
                route: '/teacher/weekly-evaluation',
              ),
              QuickAction(
                label: 'الاختبارات الشهرية',
                icon: Icons.assignment_rounded,
                color: AppColors.success,
                route: '/teacher/monthly-exams',
              ),
            ]),
            const SizedBox(height: 14),

            // Today's Tasks
            const AppSectionTitle(title: 'المهام اليوم', action: 'الكل'),
            const SizedBox(height: 10),

            if (isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else ...[
              if (pendingReports > 0)
                InfoTile(
                  title: 'تقرير المتابعة اليومي',
                  subtitle: pendingReports == 1
                      ? 'تقرير واحد لم يُقدّم بعد'
                      : '$pendingReports تقارير لم تُقدّم بعد',
                  icon: Icons.description_outlined,
                  color: AppColors.warning,
                  onTap: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
                ),
              if (pendingEvaluations > 0)
                Padding(
                  padding: EdgeInsets.only(top: pendingReports > 0 ? 10 : 0),
                  child: InfoTile(
                    title: 'التقييم الأسبوعي',
                    subtitle: pendingEvaluations == 1
                        ? 'تقييم واحد معلّق'
                        : '$pendingEvaluations تقييمات معلّقة',
                    icon: Icons.fact_check_outlined,
                    color: AppColors.info,
                    onTap: () => Navigator.pushNamed(context, '/teacher/weekly-evaluation'),
                  ),
                ),
              if (pendingReports == 0 && pendingEvaluations == 0)
                const AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                        SizedBox(width: 8),
                        Text('لا توجد مهام معلّقة',
                            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('تقرير جديد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
