import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorReportsScreen extends StatefulWidget {
  const SupervisorReportsScreen({super.key});
  @override
  State<SupervisorReportsScreen> createState() => _SupervisorReportsScreenState();
}

class _SupervisorReportsScreenState extends State<SupervisorReportsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final items = [
      _R('تقرير زيارة', 'مركز النور — 1446/11/05', Icons.event_available_rounded, BadgeKind.success, 'معتمد'),
      _R('إشراف تربوي', 'أ. سعد القحطاني', Icons.school_rounded, BadgeKind.warning, 'قيد المراجعة'),
      _R('اعتماد اختبار شهري', 'حلقة البقرة', Icons.assignment_rounded, BadgeKind.info, 'بانتظار'),
      _R('تقرير حالة طالب', 'فيصل الزهراني', Icons.report_problem_rounded, BadgeKind.danger, 'حرج'),
      _R('تقرير شهري', 'مركز الفرقان', Icons.assessment_rounded, BadgeKind.success, 'مرسل'),
    ];

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث في التقارير', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'الزيارات', 'الإشراف', 'الاعتمادات', 'الحالات'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          const KpiGrid(items: [
            KpiCard(label: 'هذا الأسبوع', value: '12', icon: Icons.today_rounded, color: AppColors.primary),
            KpiCard(label: 'بانتظار الاعتماد', value: '5', icon: Icons.hourglass_top_rounded, color: AppColors.warning),
            KpiCard(label: 'معتمدة', value: '42', icon: Icons.verified_rounded, color: AppColors.success),
            KpiCard(label: 'مرجَعة', value: '2', icon: Icons.replay_rounded, color: AppColors.danger),
          ]),
          const SizedBox(height: 12),
          const AppSectionTitle(title: 'أحدث التقارير'),
          const SizedBox(height: 8),
          ...items.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EntityListCard(
                  leading: r.icon,
                  title: r.title,
                  subtitle: r.subtitle,
                  badgeText: r.status,
                  badgeKind: r.kind,
                ),
              )),
        ],
      ),
    );
  }
}

class _R {
  final String title;
  final String subtitle;
  final IconData icon;
  final BadgeKind kind;
  final String status;
  const _R(this.title, this.subtitle, this.icon, this.kind, this.status);
}
