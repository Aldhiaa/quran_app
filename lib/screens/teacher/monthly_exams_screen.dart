import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamsScreen extends StatefulWidget {
  const MonthlyExamsScreen({super.key});

  @override
  State<MonthlyExamsScreen> createState() => _MonthlyExamsScreenState();
}

class _MonthlyExamsScreenState extends State<MonthlyExamsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TeacherProvider>().loadMonthlyTests();
    });
  }

  Future<void> _refresh() async {
    await context.read<TeacherProvider>().loadMonthlyTests();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final tests = teacher.monthlyTests;
    final isLoading = teacher.isLoading;

    // Filter
    var filtered = tests;
    if (_filter == 1) {
      filtered = tests.where((t) => t['status'] == 'pending' || t['status'] == 'upcoming').toList();
    } else if (_filter == 2) {
      filtered = tests.where((t) => t['status'] == 'completed').toList();
    }

    return GreenHeaderScaffold(
      title: 'الاختبارات الشهرية',
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            FilterChipsBar(
              items: const ['الكل', 'قادمة', 'منتهية'],
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
                    Icon(Icons.assignment_rounded, size: 48, color: AppColors.muted),
                    SizedBox(height: 12),
                    Text('لا توجد اختبارات',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                    SizedBox(height: 4),
                    Text('قم بإنشاء اختبار جديد للبدء',
                        style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  ]),
                ),
              )
            else
              ...filtered.map((test) {
                final title = test['title'] as String? ?? test['name'] as String? ?? 'اختبار شهري';
                final month = test['month'] as String? ?? test['test_month'] as String? ?? '—';
                final status = test['status'] as String? ?? 'pending';
                final studentsEntered = test['students_entered'] as int? ?? 0;
                final totalStudents = test['total_students'] as int? ?? 0;

                BadgeKind badgeKind;
                String statusText;
                switch (status) {
                  case 'completed':
                    badgeKind = BadgeKind.success;
                    statusText = 'منتهي';
                    break;
                  case 'in_progress':
                    badgeKind = BadgeKind.warning;
                    statusText = 'قيد التنفيذ';
                    break;
                  default:
                    badgeKind = BadgeKind.info;
                    statusText = 'قادم';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => Navigator.pushNamed(context, '/teacher/exam-results'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.assignment_rounded,
                                color: AppColors.accentGold, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(month,
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                          StatusBadge(text: statusText, kind: badgeKind),
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          Icon(Icons.people_rounded, size: 16, color: AppColors.muted),
                          const SizedBox(width: 4),
                          Text('تم إدخال $studentsEntered من $totalStudents طالب',
                              style: TextStyle(color: AppColors.muted, fontSize: 12)),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/teacher/grades-entry'),
                            icon: const Icon(Icons.edit_rounded, size: 16),
                            label: const Text('إدخال الدرجات', style: TextStyle(fontSize: 12)),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/teacher/monthly-exam-create'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('اختبار جديد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
