import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamsScreen extends StatefulWidget {
  const MonthlyExamsScreen({super.key});
  @override
  State<MonthlyExamsScreen> createState() => _MonthlyExamsScreenState();
}

class _MonthlyExamsScreenState extends State<MonthlyExamsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final exams = [
      _E('اختبار شهر شعبان', '1446/08', BadgeKind.success, 'معتمد', 24),
      _E('اختبار شهر رجب', '1446/07', BadgeKind.warning, 'بانتظار الاعتماد', 22),
      _E('اختبار شهر جمادى الآخرة', '1446/06', BadgeKind.danger, 'مُرجَع', 18),
      _E('اختبار شهر جمادى الأولى', '1446/05', BadgeKind.neutral, 'مسودة', 0),
    ];
    return GreenHeaderScaffold(
      title: 'الاختبارات الشهرية',
      headerExtra: FilterChipsBar(
        items: const ['الكل', 'مسودة', 'بانتظار', 'معتمد', 'مرجع'],
        selected: _filter,
        onChanged: (i) => setState(() => _filter = i),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/teacher/monthly-exam-create'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إنشاء اختبار', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: exams.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          onTap: () => Navigator.pushNamed(context, '/teacher/exam-results'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.assignment_rounded, color: AppColors.accentGold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exams[i].title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(exams[i].month, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                    ],
                  ),
                ),
                StatusBadge(text: exams[i].status, kind: exams[i].kind),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.groups_rounded, color: AppColors.muted, size: 16),
                const SizedBox(width: 4),
                Text('${exams[i].entered} طالب مُدخل',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/teacher/grades-entry'),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('إدخال الدرجات'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _E {
  final String title;
  final String month;
  final BadgeKind kind;
  final String status;
  final int entered;
  const _E(this.title, this.month, this.kind, this.status, this.entered);
}
