import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideReportsScreen extends StatefulWidget {
  const GuideReportsScreen({super.key});
  @override
  State<GuideReportsScreen> createState() => _GuideReportsScreenState();
}

class _GuideReportsScreenState extends State<GuideReportsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();
    final r = guide.reportsData;

    final visits = r['visits'] is Map
        ? Map<String, dynamic>.from(r['visits'] as Map)
        : <String, dynamic>{};
    final training = r['training'] is Map
        ? Map<String, dynamic>.from(r['training'] as Map)
        : <String, dynamic>{};
    final plans = r['monthly_plans'] is Map
        ? Map<String, dynamic>.from(r['monthly_plans'] as Map)
        : <String, dynamic>{};

    final reportItems = [
      _R('تقرير زيارة', 'إجمالي الزيارات: ${visits['total'] ?? 0}',
          Icons.event_available_rounded, BadgeKind.success, 'مكتمل'),
      _R('الإشراف التربوي',
          'زيارات الإشراف: ${visits['submitted'] ?? 0}',
          Icons.school_rounded, BadgeKind.warning, 'قيد المراجعة'),
      _R('خطط شهرية', 'معتمد: ${plans['approved'] ?? 0} — معلق: ${plans['pending'] ?? 0}',
          Icons.menu_book_rounded, BadgeKind.info, 'بانتظار'),
      _R('احتياجات تدريبية', 'مفتوحة: ${training['open_needs'] ?? 0}',
          Icons.psychology_alt_rounded, BadgeKind.danger, 'عاجل'),
    ];

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'الزيارات', 'الإشراف', 'النموذجية', 'التدريب'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                KpiGrid(items: [
                  KpiCard(
                    label: 'هذا الأسبوع',
                    value: '${visits['this_week'] ?? 0}',
                    icon: Icons.today_rounded,
                    color: AppColors.primary,
                  ),
                  KpiCard(
                    label: 'قيد المراجعة',
                    value: '${visits['submitted'] ?? 0}',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  ),
                  KpiCard(
                    label: 'معتمدة',
                    value: '${visits['completed'] ?? 0}',
                    icon: Icons.verified_rounded,
                    color: AppColors.success,
                  ),
                  KpiCard(
                    label: 'متأخرة',
                    value: '${plans['returned'] ?? 0}',
                    icon: Icons.report_problem_rounded,
                    color: AppColors.danger,
                  ),
                ]),
                const SizedBox(height: 12),
                const AppSectionTitle(title: 'أحدث التقارير'),
                const SizedBox(height: 8),
                if (guide.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppErrorState(message: guide.error!),
                  ),
                ...reportItems.map((ri) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: EntityListCard(
                        leading: ri.icon,
                        title: ri.title,
                        subtitle: ri.subtitle,
                        badgeText: ri.status,
                        badgeKind: ri.kind,
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
