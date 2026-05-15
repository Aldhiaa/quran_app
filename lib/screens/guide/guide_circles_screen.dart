import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideCirclesScreen extends StatefulWidget {
  const GuideCirclesScreen({super.key});
  @override
  State<GuideCirclesScreen> createState() => _GuideCirclesScreenState();
}

class _GuideCirclesScreenState extends State<GuideCirclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadCircles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    return GreenHeaderScaffold(
      title: 'مراقبة الحلقات',
      headerExtra: SearchFilterBar(hint: 'بحث عن حلقة', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                if (guide.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppErrorState(message: guide.error!),
                  ),
                if (guide.circles.isEmpty && !guide.isLoading)
                  const AppEmptyState(message: 'لا توجد حلقات')
                else
                  ...guide.circles.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          child: Row(children: [
                            ProgressRing(
                              value: ((c['active_students_count'] ?? 0) / 30).clamp(0.0, 1.0),
                              size: 48,
                              strokeWidth: 5,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${c['name'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 3),
                                  Text('${c['center']['name'] ?? c['teacher']['full_name'] ?? ''}',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                ],
                              ),
                            ),
                            StatusBadge(
                              text: '${c['active_students_count'] ?? 0} طالبة',
                              kind: BadgeKind.info,
                            ),
                          ]),
                        ),
                      )),
              ],
            ),
    );
  }
}
