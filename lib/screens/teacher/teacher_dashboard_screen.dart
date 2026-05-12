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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final teacher = Provider.of<TeacherProvider>(context);
    final home = teacher.home;
    final kpis = home['kpis'] is Map ? Map<String, dynamic>.from(home['kpis'] as Map) : home;

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
          KpiGrid(items: [
            KpiCard(label: 'الحلقات', value: '${kpis['circles_count'] ?? kpis['assigned_circles_count'] ?? 2}', icon: Icons.menu_book_rounded, color: AppColors.primary),
            KpiCard(label: 'الطلاب', value: '${kpis['students_count'] ?? kpis['active_students_count'] ?? 24}', icon: Icons.groups_rounded, color: AppColors.info),
            KpiCard(label: 'الحضور اليوم', value: '${kpis['today_present_count'] ?? kpis['present_count'] ?? 21}', icon: Icons.check_circle_rounded, color: AppColors.success, sub: '${kpis['attendance_rate'] ?? '٪87'}'),
            KpiCard(label: 'الإختبارات', value: '${kpis['monthly_tests_count'] ?? kpis['upcoming_monthly_tests_count'] ?? 5}', icon: Icons.assignment_turned_in_rounded, color: AppColors.accentGold),
          ]),
          const SizedBox(height: 14),
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
                    StatusBadge(text: 'جارية', kind: BadgeKind.success),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [
                  const ProgressRing(value: .87, size: 72, strokeWidth: 8),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('حلقة البقرة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        SizedBox(height: 4),
                        Text('21 / 24 حاضر', style: TextStyle(color: AppColors.muted)),
                        SizedBox(height: 4),
                        Text('من 4:30 — إلى 6:00', style: TextStyle(color: AppColors.muted, fontSize: 12)),
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
          const AppSectionTitle(title: 'إجراءات سريعة'),
          const SizedBox(height: 10),
          QuickActionGrid(actions: [
            QuickAction(label: 'تسجيل الحضور', icon: Icons.how_to_reg_rounded, color: AppColors.primary, route: '/teacher/attendance-entry'),
            QuickAction(label: 'دفتر المتابعة', icon: Icons.menu_book_rounded, color: AppColors.info, route: '/teacher/daily-followup'),
            QuickAction(label: 'التقييم الأسبوعي', icon: Icons.star_rate_rounded, color: AppColors.accentGold, route: '/teacher/weekly-evaluation'),
            QuickAction(label: 'الاختبارات الشهرية', icon: Icons.assignment_rounded, color: AppColors.success, route: '/teacher/monthly-exams'),
          ]),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'المهام اليوم', action: 'الكل'),
          const SizedBox(height: 10),
          InfoTile(
            title: 'تقرير المتابعة اليومي',
            subtitle: 'لم يتم إدخال التقرير بعد',
            icon: Icons.description_outlined,
            color: AppColors.warning,
            onTap: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'التقييم الأسبوعي',
            subtitle: 'تقييم السلوك والالتزام',
            icon: Icons.fact_check_outlined,
            color: AppColors.info,
            onTap: () => Navigator.pushNamed(context, '/teacher/weekly-evaluation'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'متابعة طالب ضعيف',
            subtitle: 'محمد العتيبي — حلقة البقرة',
            icon: Icons.priority_high_rounded,
            color: AppColors.danger,
            onTap: () => Navigator.pushNamed(context, '/teacher/student-detail'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('تقرير جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
