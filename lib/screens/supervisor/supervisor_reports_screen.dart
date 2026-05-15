import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorReportsScreen extends StatefulWidget {
  const SupervisorReportsScreen({super.key});
  @override
  State<SupervisorReportsScreen> createState() => _SupervisorReportsScreenState();
}

class _SupervisorReportsScreenState extends State<SupervisorReportsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final items = sup.reports;

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث في التقارير', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'الزيارات', 'الإشراف', 'الاعتمادات', 'الحالات'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                const KpiGrid(items: [
                  KpiCard(label: 'هذا الأسبوع', value: '-', icon: Icons.today_rounded, color: AppColors.primary),
                  KpiCard(label: 'بانتظار الاعتماد', value: '-', icon: Icons.hourglass_top_rounded, color: AppColors.warning),
                  KpiCard(label: 'معتمدة', value: '-', icon: Icons.verified_rounded, color: AppColors.success),
                  KpiCard(label: 'مرجَعة', value: '-', icon: Icons.replay_rounded, color: AppColors.danger),
                ]),
                const SizedBox(height: 12),
                const AppSectionTitle(title: 'أحدث التقارير'),
                const SizedBox(height: 8),
                ...items.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: EntityListCard(
                        leading: Icons.event_available_rounded,
                        title: '${r['visit_type'] ?? 'زيارة'} — ${r['center'] is Map ? r['center']['name'] ?? '' : ''}',
                        subtitle: '${r['visit_date'] ?? ''}',
                        badgeText: '${r['status'] ?? ''}',
                        badgeKind: r['status'] == 'completed' ? BadgeKind.success : BadgeKind.warning,
                      ),
                    )),
              ],
            ),
    );
  }
}
