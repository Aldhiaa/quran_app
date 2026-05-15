import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideTrainingPlanScreen extends StatefulWidget {
  const GuideTrainingPlanScreen({super.key});
  @override
  State<GuideTrainingPlanScreen> createState() => _GuideTrainingPlanScreenState();
}

class _GuideTrainingPlanScreenState extends State<GuideTrainingPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadTrainingPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    return GreenHeaderScaffold(
      title: 'الخطة التدريبية',
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إضافة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: guide.trainingPlan.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final w = guide.trainingPlan[i];
                final status = '${w['status'] ?? 'planned'}';
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(alpha: .18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.school_rounded,
                              color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${w['title'] ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text('${w['date'] ?? ''} — ${w['location'] ?? ''}',
                                  style: const TextStyle(
                                      color: AppColors.muted, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: _statusLabel(status),
                          kind: _statusKind(status),
                        ),
                      ]),
                      if (w['description'] != null &&
                          '${w['description']}' != 'null' &&
                          '${w['description']}' != '') ...[
                        const SizedBox(height: 8),
                        Text('${w['description']}',
                            style: const TextStyle(
                                color: AppColors.muted, fontSize: 12.5)),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'confirmed':
        return 'مؤكدة';
      case 'completed':
        return 'منتهية';
      case 'cancelled':
        return 'ملغاة';
      default:
        return 'مخططة';
    }
  }

  BadgeKind _statusKind(String s) {
    switch (s) {
      case 'confirmed':
        return BadgeKind.success;
      case 'completed':
        return BadgeKind.info;
      case 'cancelled':
        return BadgeKind.danger;
      default:
        return BadgeKind.warning;
    }
  }
}
