import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideEducationalSupervisionScreen extends StatefulWidget {
  const GuideEducationalSupervisionScreen({super.key});
  @override
  State<GuideEducationalSupervisionScreen> createState() =>
      _GuideEducationalSupervisionScreenState();
}

class _GuideEducationalSupervisionScreenState
    extends State<GuideEducationalSupervisionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadEducationalSupervisions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    return GreenHeaderScaffold(
      title: 'الإشراف التربوي',
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: guide.educationalSupervisions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final s = guide.educationalSupervisions[i];
                final visit = s['supervision_visit'] as Map<String, dynamic>? ?? {};
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: .12),
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
                              Text('${visit['circle']['name'] ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text('${visit['center']['name'] ?? ''}',
                                  style: const TextStyle(
                                      color: AppColors.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 14, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text('${s['created_at'] ?? visit['visit_date'] ?? ''}',
                            style: const TextStyle(
                                color: AppColors.muted, fontSize: 12)),
                      ]),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
