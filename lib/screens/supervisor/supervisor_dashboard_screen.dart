import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorDashboardScreen extends StatefulWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  State<SupervisorDashboardScreen> createState() => _SupervisorDashboardScreenState();
}

class _SupervisorDashboardScreenState extends State<SupervisorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final sup = Provider.of<SupervisorProvider>(context);
    final home = sup.home;
    final kpis = home['kpis'] is Map ? Map<String, dynamic>.from(home['kpis'] as Map) : <String, dynamic>{};
    final pending = sup.pendingApprovals;

    return GreenHeaderScaffold(
      title: 'لوحة المشرف',
      showBack: false,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/common/notifications'),
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
      ],
      headerExtra: RoleDashboardHeader(
        name: auth.user?.name ?? 'مشرف المركز',
        role: 'مشرف مركز',
        onTap: () => Navigator.pushNamed(context, '/settings/profile'),
      ),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                if (sup.error != null) ...[
                  AppCard(
                    color: AppColors.danger.withValues(alpha: .06),
                    child: Text(sup.error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                ],
                KpiGrid(items: [
                  KpiCard(label: 'المراكز', value: '${kpis['assigned_centers_count'] ?? kpis['centers_count'] ?? 0}', icon: Icons.business_rounded, color: AppColors.primary),
                  KpiCard(label: 'الحلقات النشطة', value: '${kpis['active_circles_count'] ?? 0}', icon: Icons.menu_book_rounded, color: AppColors.info),
                  KpiCard(label: 'زيارات اليوم', value: '${kpis['today_visits_count'] ?? 0}', icon: Icons.event_available_rounded, color: AppColors.warning),
                  KpiCard(label: 'الحضور', value: '${_fmt(kpis['attendance_rate'])}%', icon: Icons.check_circle_rounded, color: AppColors.success),
                  KpiCard(label: 'بانتظار الاعتماد', value: '${kpis['pending_approvals_count'] ?? 0}', icon: Icons.hourglass_top_rounded, color: AppColors.accentGold),
                  KpiCard(label: 'حالات متابعة', value: '${kpis['returned_reports_count'] ?? 0}', icon: Icons.priority_high_rounded, color: AppColors.danger),
                ]),
                const SizedBox(height: 14),
                if (kpis['today_visits_count'] != null && (kpis['today_visits_count'] as num) > 0)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text('زيارات اليوم', style: TextStyle(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          StatusBadge(text: '${kpis['today_visits_count']} زيارات', kind: BadgeKind.info),
                        ]),
                        const SizedBox(height: 8),
                        Text('لديك ${kpis['today_visits_count']} زيارة مجدولة اليوم',
                            style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                const AppSectionTitle(title: 'بانتظار الاعتماد'),
                const SizedBox(height: 8),
                if (pending is Map && pending.isNotEmpty) ...[
                  if (pending['daily_sessions'] != null && (pending['daily_sessions'] as num) > 0)
                    _PendingRow('جلسات يومية', '${pending['daily_sessions']}', Icons.calendar_view_day_rounded, AppColors.warning),
                  if (pending['monthly_plans'] != null && (pending['monthly_plans'] as num) > 0)
                    _PendingRow('خطط شهرية', '${pending['monthly_plans']}', Icons.assignment_rounded, AppColors.info),
                  if (pending['monthly_tests'] != null && (pending['monthly_tests'] as num) > 0)
                    _PendingRow('اختبارات شهرية', '${pending['monthly_tests']}', Icons.menu_book_rounded, AppColors.accentGold),
                  if (pending['weekly_evaluations'] != null && (pending['weekly_evaluations'] as num) > 0)
                    _PendingRow('تقييمات أسبوعية', '${pending['weekly_evaluations']}', Icons.rate_review_rounded, AppColors.primary),
                ] else
                  const Text('لا توجد طلبات معلقة', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 14),
                const AppSectionTitle(title: 'إجراءات سريعة'),
                const SizedBox(height: 10),
                QuickActionGrid(actions: [
                  QuickAction(label: 'مراكزي', icon: Icons.business_rounded, color: AppColors.primary, route: '/supervisor/centers'),
                  QuickAction(label: 'المعلمون', icon: Icons.groups_2_rounded, color: AppColors.info, route: '/supervisor/teachers'),
                  QuickAction(label: 'مراقبة الحلقات', icon: Icons.visibility_rounded, color: AppColors.accentGold, route: '/supervisor/circles'),
                  QuickAction(label: 'الزيارات', icon: Icons.event_available_rounded, color: AppColors.success, route: '/supervisor/visits'),
                  QuickAction(label: 'تنبيهات الغياب', icon: Icons.notifications_active_rounded, color: AppColors.warning, route: '/supervisor/attendance-alerts'),
                  QuickAction(label: 'الإشراف التربوي', icon: Icons.school_rounded, color: AppColors.primaryDark, route: '/supervisor/educational-supervision'),
                  QuickAction(label: 'الحالات الحرجة', icon: Icons.report_problem_rounded, color: AppColors.danger, route: '/supervisor/student-risk-cases'),
                  QuickAction(label: 'التواصل مع أولياء', icon: Icons.forum_rounded, color: AppColors.info, route: '/supervisor/parent-communication'),
                  QuickAction(label: 'متابعة المهام', icon: Icons.task_alt_rounded, color: AppColors.success, route: '/supervisor/tasks'),
                  QuickAction(label: 'طلبات المراكز', icon: Icons.mail_outline_rounded, color: AppColors.accentGold, route: '/supervisor/requests'),
                  QuickAction(label: 'الاعتمادات', icon: Icons.verified_rounded, color: AppColors.primary, route: '/supervisor/reports'),
                  QuickAction(label: 'التقارير', icon: Icons.assessment_rounded, color: AppColors.primaryDark, route: '/supervisor/reports'),
                ]),
              ],
            ),
    );
  }

  String _fmt(dynamic v) {
    if (v == null) return '0';
    if (v is double) return v.toStringAsFixed(1);
    return v.toString();
  }
}

class _PendingRow extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color color;
  const _PendingRow(this.label, this.count, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(color: color.withValues(alpha: .15), borderRadius: BorderRadius.circular(20)),
          child: Text(count, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
        ),
      ]),
    );
  }
}
