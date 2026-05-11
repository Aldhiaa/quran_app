import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      _R('أحمد العتيبي', 86, 'ممتاز', AppColors.success),
      _R('عبدالله القحطاني', 72, 'جيد جداً', AppColors.primary),
      _R('محمد الدوسري', 58, 'مقبول', AppColors.warning),
      _R('سعد الشهري', 78, 'جيد جداً', AppColors.primary),
      _R('فيصل الزهراني', 44, 'ضعيف', AppColors.danger),
    ];

    return GreenHeaderScaffold(
      title: 'نتائج الاختبار',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: .68,
            size: 60,
            strokeWidth: 7,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '68٪',
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اختبار شهر شعبان',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 4),
                Text('متوسط النتائج • 24 طالب',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ]),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: rows.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => AppCard(
          onTap: () => Navigator.pushNamed(context, '/teacher/exam-result-detail'),
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: rows[i].color.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('${rows[i].score}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: rows[i].color)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rows[i].name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(rows[i].grade,
                      style: TextStyle(color: rows[i].color, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
          ]),
        ),
      ),
    );
  }
}

class _R {
  final String name;
  final int score;
  final String grade;
  final Color color;
  const _R(this.name, this.score, this.grade, this.color);
}
