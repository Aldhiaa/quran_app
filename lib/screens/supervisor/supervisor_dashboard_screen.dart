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
    final supervisor = Provider.of<SupervisorProvider>(context);
    final home = supervisor.home;
    final kpis = home['kpis'] is Map ? Map<String, dynamic>.from(home['kpis'] as Map) : home;

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
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (supervisor.error != null) ...[
            AppCard(
              color: AppColors.danger.withValues(alpha: .06),
              child: Text(supervisor.error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
          ],
          KpiGrid(items: [
            KpiCard(label: 'المراكز', value: '${kpis['centers_count'] ?? kpis['assigned_centers_count'] ?? 4}', icon: Icons.business_rounded, color: AppColors.primary),
            KpiCard(label: 'الحلقات النشطة', value: '${kpis['active_circles_count'] ?? 12}', icon: Icons.menu_book_rounded, color: AppColors.info),
            KpiCard(label: 'زيارات اليوم', value: '${kpis['today_visits_count'] ?? 3}', icon: Icons.event_available_rounded, color: AppColors.warning),
            KpiCard(label: 'الحضور', value: '${kpis['attendance_rate'] ?? '٪87'}', icon: Icons.check_circle_rounded, color: AppColors.success),
            KpiCard(label: 'بانتظار الاعتماد', value: '${kpis['pending_approvals_count'] ?? 7}', icon: Icons.hourglass_top_rounded, color: AppColors.accentGold),
            KpiCard(label: 'حالات متابعة', value: '${kpis['weak_students_count'] ?? kpis['risk_students_count'] ?? 5}', icon: Icons.priority_high_rounded, color: AppColors.danger),
          ]),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('زيارات اليوم', style: TextStyle(fontWeight: FontWeight.w800)),
                  Spacer(),
                  StatusBadge(text: '3 زيارات', kind: BadgeKind.info),
                ]),
                const SizedBox(height: 12),
                _VisitMini(time: '9:30 ص', center: 'مركز النور', circle: 'حلقة البقرة'),
                const Divider(),
                _VisitMini(time: '11:00 ص', center: 'مركز الفرقان', circle: 'حلقة آل عمران'),
              ],
            ),
          ),
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
}

class _VisitMini extends StatelessWidget {
  final String time;
  final String center;
  final String circle;
  const _VisitMini({required this.time, required this.center, required this.circle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(time, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(center, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(circle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
      ]),
    );
  }
}
