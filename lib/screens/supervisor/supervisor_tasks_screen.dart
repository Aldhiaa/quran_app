import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorTasksScreen extends StatefulWidget {
  const SupervisorTasksScreen({super.key});
  @override
  State<SupervisorTasksScreen> createState() => _SupervisorTasksScreenState();
}

class _SupervisorTasksScreenState extends State<SupervisorTasksScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final tasks = sup.tasks;

    return GreenHeaderScaffold(
      title: 'متابعة المهام',
      headerExtra: SearchFilterBar(hint: 'بحث في المهام', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'مفتوحة', 'قيد التنفيذ', 'مكتملة'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                ...tasks.map((t) {
                  final status = '${t['status'] ?? ''}';
                  final done = status == 'completed';
                  final kind = done ? BadgeKind.success : (status == 'in_progress' ? BadgeKind.info : (t['priority'] == 'urgent' ? BadgeKind.danger : BadgeKind.warning));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(children: [
                        Container(
                          width: 8,
                          height: 60,
                          decoration: BoxDecoration(
                            color: badgeColor(kind),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: badgeColor(kind).withValues(alpha: .14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            done ? Icons.task_alt_rounded : Icons.priority_high_rounded,
                            color: badgeColor(kind),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${t['title'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  decoration: done ? TextDecoration.lineThrough : null,
                                  color: done ? AppColors.muted : AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                t['assignee'] is Map ? 'مسند إلى: ${t['assignee']['name'] ?? ''}' : '',
                                style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: status == 'open' ? 'مفتوحة' : (status == 'in_progress' ? 'قيد التنفيذ' : (status == 'completed' ? 'مكتملة' : status)),
                          kind: kind,
                        ),
                      ]),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
