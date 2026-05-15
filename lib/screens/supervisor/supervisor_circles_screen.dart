import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorCirclesScreen extends StatefulWidget {
  const SupervisorCirclesScreen({super.key});

  @override
  State<SupervisorCirclesScreen> createState() => _SupervisorCirclesScreenState();
}

class _SupervisorCirclesScreenState extends State<SupervisorCirclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadCircles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final circles = sup.circles;

    return GreenHeaderScaffold(
      title: 'مراقبة الحلقات',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sup.circles.isEmpty && sup.error != null
              ? AppErrorState(message: sup.error!, onRetry: () => context.read<SupervisorProvider>().loadCircles())
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  itemCount: circles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final c = circles[i];
                    return AppCard(
                      child: Row(
                        children: [
                          ProgressRing(
                            value: 0.5,
                            size: 56,
                            strokeWidth: 7,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${c['name'] ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w800)),
                                const SizedBox(height: 3),
                                Text('${c['center'] is Map ? c['center']['name'] : c['center_name'] ?? ''}',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.groups_rounded, size: 14, color: AppColors.muted),
                                  const SizedBox(width: 4),
                                  Text('${c['active_students_count'] ?? c['students_count'] ?? 0} طالب',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                ]),
                              ],
                            ),
                          ),
                          if (c['teacher'] is Map)
                            StatusBadge(text: '${c['teacher']?.['full_name'] ?? ''}', kind: BadgeKind.info),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
