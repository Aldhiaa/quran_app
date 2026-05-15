import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class HalaqatScreen extends StatefulWidget {
  const HalaqatScreen({super.key});

  @override
  State<HalaqatScreen> createState() => _HalaqatScreenState();
}

class _HalaqatScreenState extends State<HalaqatScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TeacherProvider>().loadCircles();
    });
  }

  Future<void> _refresh() async {
    await context.read<TeacherProvider>().loadCircles();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final circles = teacher.circles;
    final isLoading = teacher.isLoading;

    // Filter circles
    var filtered = circles;
    if (_filter == 1) {
      filtered = circles.where((c) => c['is_active'] == true || c['status'] == 'active').toList();
    } else if (_filter == 2) {
      filtered = circles.where((c) => c['status'] == 'needs_followup').toList();
    }

    return GreenHeaderScaffold(
      title: 'الحلقات',
      showBack: false,
      headerExtra: SearchFilterBar(
        hint: 'بحث عن حلقة',
        onChanged: (_) {},
      ),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            FilterChipsBar(
              items: const ['الكل', 'نشطة', 'متابعة'],
              selected: _filter,
              onChanged: (i) => setState(() => _filter = i),
            ),
            const SizedBox(height: 12),

            if (isLoading && filtered.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ))
            else if (filtered.isEmpty)
              const AppCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(children: [
                    Icon(Icons.menu_book_rounded, size: 48, color: AppColors.muted),
                    SizedBox(height: 12),
                    Text('لا توجد حلقات',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                  ]),
                ),
              )
            else
              ...filtered.map((circle) {
                final name = circle['name'] as String? ?? 'حلقة';
                final schedule = circle['schedule'] as String? ?? circle['time'] as String? ?? '—';
                final studentCount = circle['students_count'] as int? ??
                    circle['active_students_count'] as int? ??
                    0;
                final progress = (circle['average_progress'] as num?)?.toDouble() ?? 0.0;
                final isActive = circle['is_active'] as bool? ?? true;
                final statusText = isActive ? 'نشطة' : 'متوقفة';
                final statusKind = isActive ? BadgeKind.success : BadgeKind.warning;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () {
                      teacher.selectCircle(circle);
                      Navigator.pushNamed(context, '/teacher/daily-followup');
                    },
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.menu_book_rounded,
                                color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(schedule,
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                          StatusBadge(text: statusText, kind: statusKind),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          _CircleStat(label: 'الطلاب', value: '$studentCount'),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Text('المستوى',
                                      style: TextStyle(color: AppColors.muted, fontSize: 11)),
                                  const Spacer(),
                                  Text('${(progress * 100).round()}٪',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 11)),
                                ]),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: AppColors.primary.withValues(alpha: .1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

class _CircleStat extends StatelessWidget {
  final String label;
  final String value;

  const _CircleStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 18)),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      ],
    );
  }
}
