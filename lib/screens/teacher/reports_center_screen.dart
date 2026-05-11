import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ReportsCenterScreen extends StatefulWidget {
  const ReportsCenterScreen({super.key});
  @override
  State<ReportsCenterScreen> createState() => _ReportsCenterScreenState();
}

class _ReportsCenterScreenState extends State<ReportsCenterScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final items = [
      _R('تقرير المتابعة اليومي', 'حلقة البقرة • 1446/11/05', BadgeKind.success, 'معتمد', Icons.description_rounded),
      _R('تقييم أسبوعي', 'الأسبوع 45', BadgeKind.warning, 'قيد المراجعة', Icons.fact_check_rounded),
      _R('اختبار شهر شعبان', 'حلقة البقرة', BadgeKind.danger, 'مُرجَع', Icons.assignment_rounded),
      _R('تقرير المتابعة اليومي', 'حلقة آل عمران • 1446/11/05', BadgeKind.neutral, 'مسودة', Icons.description_rounded),
      _R('تقييم أسبوعي', 'الأسبوع 44', BadgeKind.success, 'معتمد', Icons.fact_check_rounded),
    ];

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث في التقارير', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'اليومي', 'الأسبوعي', 'الشهري', 'المُرجعة'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          const KpiGrid(items: [
            KpiCard(label: 'تقارير اليوم', value: '4', icon: Icons.today_rounded, color: AppColors.primary),
            KpiCard(label: 'قيد المراجعة', value: '2', icon: Icons.hourglass_top_rounded, color: AppColors.warning),
            KpiCard(label: 'معتمدة', value: '38', icon: Icons.verified_rounded, color: AppColors.success),
            KpiCard(label: 'مُرجَعة', value: '1', icon: Icons.replay_rounded, color: AppColors.danger),
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
  final BadgeKind kind;
  final String status;
  final IconData icon;
  const _R(this.title, this.subtitle, this.kind, this.status, this.icon);
}
