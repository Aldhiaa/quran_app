import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideReportsScreen extends StatefulWidget {
  const GuideReportsScreen({super.key});
  @override
  State<GuideReportsScreen> createState() => _GuideReportsScreenState();
}

class _GuideReportsScreenState extends State<GuideReportsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final items = [
      _R('تقرير زيارة', 'مركز الإيمان — 1446/11/05', Icons.event_available_rounded, BadgeKind.success, 'مكتمل'),
      _R('إشراف تربوي', 'أ. منى السبيعي', Icons.school_rounded, BadgeKind.warning, 'قيد المراجعة'),
      _R('تقييم حلقة نموذجية', 'حلقة النور', Icons.workspace_premium_rounded, BadgeKind.info, 'بانتظار'),
      _R('احتياجات تدريبية', 'مجمعة لشهر شعبان', Icons.psychology_alt_rounded, BadgeKind.danger, 'عاجل'),
      _R('تقرير شهري شامل', 'جميع المراكز', Icons.assessment_rounded, BadgeKind.success, 'مرسل'),
    ];

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'الزيارات', 'الإشراف', 'النموذجية', 'التدريب'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          const KpiGrid(items: [
            KpiCard(label: 'هذا الأسبوع', value: '14', icon: Icons.today_rounded, color: AppColors.primary),
            KpiCard(label: 'قيد المراجعة', value: '6', icon: Icons.hourglass_top_rounded, color: AppColors.warning),
            KpiCard(label: 'معتمدة', value: '52', icon: Icons.verified_rounded, color: AppColors.success),
            KpiCard(label: 'متأخرة', value: '3', icon: Icons.report_problem_rounded, color: AppColors.danger),
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
