import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorCenterDetailScreen extends StatefulWidget {
  final int? centerId;
  const SupervisorCenterDetailScreen({super.key, this.centerId});

  @override
  State<SupervisorCenterDetailScreen> createState() => _SupervisorCenterDetailScreenState();
}

class _SupervisorCenterDetailScreenState extends State<SupervisorCenterDetailScreen> {
  int? _centerId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerId = widget.centerId ?? ModalRoute.of(context)?.settings.arguments as int?;
      if (_centerId != null && mounted) {
        context.read<SupervisorProvider>().loadCenterDetail(_centerId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final center = sup.selectedCenter;
    final centerData = center?['center'] as Map<String, dynamic>? ?? center ?? <String, dynamic>{};
    final circlesList = center?['circles'] as List<dynamic>? ?? [];

    return GreenHeaderScaffold(
      title: 'تفاصيل المركز',
      headerExtra: centerData.isNotEmpty
          ? AppCard(
              color: Colors.white.withValues(alpha: .12),
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentGold, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.business_rounded, color: AppColors.accentGold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${centerData['name'] ?? ''}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${centerData['address'] ?? ''}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ]),
            )
          : null,
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                const KpiGrid(items: [
                  KpiCard(label: 'حلقات', value: '-', icon: Icons.menu_book_rounded, color: AppColors.primary),
                  KpiCard(label: 'معلمون', value: '-', icon: Icons.school_rounded, color: AppColors.info),
                  KpiCard(label: 'طلاب', value: '-', icon: Icons.groups_rounded, color: AppColors.success),
                  KpiCard(label: 'الزيارات', value: '-', icon: Icons.event_available_rounded, color: AppColors.accentGold),
                ]),
                const SizedBox(height: 14),
                const AppSectionTitle(title: 'الحلقات'),
                const SizedBox(height: 8),
                ...circlesList.map((c) {
                  final circle = c as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EntityListCard(
                      leading: Icons.menu_book_rounded,
                      title: '${circle['name'] ?? ''}',
                      subtitle: '${circle['active_students_count'] ?? circle['students_count'] ?? 0} طالب',
                      badgeText: circle['teacher']?['full_name'] ?? '',
                      badgeKind: BadgeKind.info,
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
